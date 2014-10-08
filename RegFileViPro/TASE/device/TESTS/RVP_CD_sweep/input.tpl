;; POWER-DELAY CHARACTERIZATION OF CD
;; Satya Nalam 03-28-2010

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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Write calculations

;; open file for writing characterization results



maxRows=512
rows = 16

;; sweep rows
while( (rows <= maxRows)

of = outfile(sprintf( nil "dataw%d.txt" rows),"w")

pchw=2

while( (pchw <= 33)

	colMux = 1
	;; Copy appropriate WRITE netlist
	if( colMux ==1 then
		cpnetlist = "cp -f ./WRITE/netlist_one netlist"
	else
		cpnetlist = "cp -f ./WRITE/netlist_mult netlist"
	)
	sh( cpnetlist )
	design(  "./netlist")

	resultsDir("./OUTW")

	VDD = <pvdd>
	desVar(	  "pchw" pchw	)
	desVar(	  "wnth" 16	)
	desVar(	  "wpu" <wpu>	)
	desVar(	  "lpu" <lpu>	)
	desVar(	  "wpd" <wpd>	)
	desVar(	  "lpd" <lpd>	)
	desVar(	  "wpg" <wpg>	)
	desVar(	  "lpg" <lpg>	)

	;PD width of IO driver chosen arbitrarily as it doesn't affect CD measurements mostly - assuming its contribution to cap is small compared to all other bitline cap components.
	desVar("ldef" <ldef>)
	desVar("wdef" <wdef>)
	desVar("tper" <tper>)
	desVar("trf" <trf>)
	desVar("twl" <tper>/6)
	desVar("tdly" <tdly>)
	desVar("cbl" <cbl>)
	desVar("NR" rows)
	desVar("colMux" colMux-1)
	desVar("pvdd" VDD    )
	desVar("cwl" <cwl>)
	desVar("cg" <cg>)
	desVar("ws" <ws>)
	desVar("numBanks" <numBanks>)
	temp( <temp> )
	option( 'reltol <reltol> 'gmin <gmin>)

	analysis('tran ?start 0 ?stop 1.1*<tper> ?step 0.01n ?strobeperiod 0.001n ?errpreset 'moderate)
	run()
	selectResult('tran)

	;; measure delays
	;; calculate bitcell flip energy	
	avg_pwrbc_w = average(getData("ICOL1.IBCA:pwr"))
	; Bitcell flip delay
	dly_bcwr = cross(v("ICOL1.IBCA.Q") VDD/2 1 'rising) - cross(v("WLA") VDD/2 1 'rising)

	; run analysis with enough WL pulse to just write, to prevent half-selected cells swinging full rail
	desVar("twl" dly_bcwr)
	analysis('tran ?start 0 ?stop 1.1*<tper> ?step 0.01n ?strobeperiod 0.001n ?errpreset 'moderate)
	run()
	selectResult('tran)
	
	;; measure delays
	;; BL discharge and precharge delay
	dly_bl_pch = cross(v("BLB") VDD*.95 1 'rising) - cross(v("PCH") VDD/2 1 'falling) 
	dly_writeDriver = cross(v("BLB") VDD*.05 1 'falling) - cross(v("WEN") VDD/2 1 'rising)

	;; measure power
	; accessed col cd and bitcell power
	avg_pwr_writeDriver = average(getData("IWRD:pwr"))+average(getData("IWRDB:pwr"))+average(getData("IWEN:pwr"))
	avg_pwr_w = average(getData("ICOL1.ICDA:pwr"))+average(getData("IPCH:pwr"))
	
	
	; half-selected col cd and bitcell power if col-mux present
	if( colMux > 1 then
		avg_pwr_hs = average(getData("ICOLD.ICDA:pwr"))
		avg_pwrbc_hs = average(getData("ICOLD.IBCA:pwr"))
	else
		avg_pwr_hs = 0
		avg_pwrbc_hs = 0
	)
	
	; calculate total CD energy across all selected columns
	energycd_w = <ws>*(avg_pwr_w + avg_pwr_hs)*1.1*<tper>
	energybc_w = <ws>*(avg_pwrbc_w + avg_pwrbc_hs)*1.1*<tper>
	energy_writeDriver= <ws>*avg_pwr_writeDriver*1.1*<tper>	

	;; write data to file
	fprintf(of,"%d\t%d\t%d\t%e\t%e\t%e\t%e\t%e\t%e\n", <numBanks>, rows, pchw, dly_bl_pch, dly_writeDriver, dly_bcwr, energycd_w, energybc_w, energy_writeDriver)
	pchw=pchw*2
	drain(of)
	)

	rows = rows*2
	close(of)
)


