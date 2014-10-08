;; POWER-DELAY CHARACTERIZATION OF SA
;; Jim Boley 3/13/2012

;; set simulator
simulator( 'spectre)
(envSetVal "spectre.opts" "multithread" 'string "on")
(envSetVal "spectre.opts" "nthreads" 'string "3")

;; set model lists
modelFile(
     '("<include>")
     '("<subN>")
     '("<subP>")
     '("<subPU>")
     '("<subPD>")
     '("<subPG>")
)

;;; 
;; characterization is not accurate b/c the number of banks has an effect
;; on the signal buffer power
char = <char>

if( char == 1 then
	maxColMux = 8 ;; current upper bound set at 
	colMux = 1 
	muxStep = 2
else
	maxColMux = <colMux>
	colMux = <colMux>
	muxStep = 2
)
;; open file for writing characterization results
of = outfile("datar.txt","w")
bcType="<bcType>"
while( (colMux <= maxColMux)

	;; Copy READ Netlist
	if( colMux ==1 then
		if( bcType == "8T" then
			cpnetlist = "cp -f ./READ/netlist_one_8T netlist"
		else
			cpnetlist = "cp -f ./READ/netlist_one netlist"
		)
	else
		if( bcType == "8T" then
			cpnetlist = "cp -f ./READ/netlist_mult_8T netlist"
		else
			cpnetlist = "cp -f ./READ/netlist_mult netlist"
		)
	)
	sh( cpnetlist )
	design(  "./netlist")
	resultsDir("./OUTR")
	if( (colMux>1) then
		cwire=<ws>*<cwl>*((colMux-1)/2)   ;;calculation for wire length
		desVar("cwire" cwire)	
	)
	VDD = <pvdd>

	desVar(   "wpu" <wpu>   )
	desVar(   "lpu" <lpu>   )
	desVar(   "wpd" <wpd>   )
	desVar(   "lpd" <lpd>   )
	desVar(   "wpg" <wpg>   )
	desVar(   "lpg" <lpg>   )
	desVar(	  "cg"  <cg>	)
	desVar("ldef" <ldef>)
	desVar("wdef" <wdef>)
	desVar("tper" <tper>)
	desVar("trf" <trf>)
	desVar("tdly" <tdly>)
	desVar("cbl" <cbl>)
	desVar("colMux" colMux )
	desVar("pvdd" VDD    )
	desVar("ws" <ws>)
	desVar("cwl" <cwl>)
	desVar("numBanks" <numBanks>)
	desVar("BL_DIFF" <BL_DIFF>)

	temp( <temp> )
	option( 'reltol <reltol> 'gmin <gmin>)

	desVar("twl"  <tper>/2)

	; run analysis 
	desVar("twl" 1e9)
	analysis('tran ?start 0 ?stop 1.1*<tper> ?step 0.01n ?strobeperiod 0.001n ?errpreset 'conservative)
	run()
	
	;; measure power
	selectResults('tran)

	avg_pwr_buf= average(getData("ICSEL:pwr"))+average(getData("ICSELB:pwr"))+average(getData("ISAE:pwr"))+average(getData("ISAPREC:pwr"))
	energy_buf=avg_pwr_buf*1.1*<tper>

	avg_pwr = average(getData("ISA:pwr"))
	energy_SA = 1.1*<tper>*avg_pwr
	etot_r = energy_SA*<ws>
	
	;; measure delays
	
	; SA resolution delay
	dly_sa = cross(v("SD") VDD/2 1 'falling) - cross(v("SAE") VDD/2 1 'rising)
	;; global interconnect delay
	dly_SAE= cross(v("SAE") VDD/2 1 'rising) - cross(v("SAE_IN") VDD/2 1 'rising) 	
	dly_CS= cross(v("CSEL") VDD/2 1 'rising) - cross(v("CSEL_IN") VDD/2 1 'rising) 
	dly_inter=max(dly_SAE,dly_CS)
	;; write data to file
	fprintf(of,"%d\t%d\t%e\t%e\t%e\t%e\n", <numBanks>,colMux,etot_r,dly_sa,energy_buf,dly_inter)
	drain(of)
	colMux=colMux*muxStep
) 
close(of)
