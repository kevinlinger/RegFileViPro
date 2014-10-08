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

;; open file for writing characterization results
of = outfile("datar.txt","w")

; reduce the loops to a single iteration if only getting metrics for a particular configuration
; sweep rows at only those points that correspond to col-mux of 1,2,4 or 8.
; initialize rows to correspond to col-mux of 8 if sweeping, otherwise to specified number of rows.
char = <char>
numWords = <memsize>/<ws>
if( char == 1 then
	maxRows = 512  ;;upper limit 512 rows
	rows = 16 ;;lower limit of 16 rows
	;rowStep = (maxRows-rows)/5 ;ensure we get atleast 5 points for the row sweep
	rowStep = 2
else
	maxRows = <NR_sweep>
	rows = <NR_sweep>
	rowStep = 2
)

;; sweep rows 
while( (rows <= maxRows)

	colMux = <colMux>
	bcType = "<bcType>"
	;; Copy appropriate READ netlist
	if( colMux ==1 then
		if( bcType=="6T" then
			cpnetlist = "cp -f ./READ/netlist_one netlist"
		else
			cpnetlist = "cp -f ./READ/netlist_one_8T netlist"
		)
	else
		if( bcType=="6T" then
			cpnetlist = "cp -f ./READ/netlist_mult netlist"
		else
			cpnetlist = "cp -f ./READ/netlist_mult_8T netlist"
		)
	)
	sh( cpnetlist )
	design(  "./netlist")
	resultsDir("./OUTR")

	VDD = <pvdd>
	desVar(	  "wpu" <wpu>	)
	desVar(	  "lpu" <lpu>	)
	desVar(	  "wpd" <wpd>	)
	desVar(	  "lpd" <lpd>	)
	desVar(	  "wpg" <wpg>	)
	desVar(	  "lpg" <lpg>	)
	desVar( "WLOffset" <WLOffset> )
	desVar( "wrd1" <wrd1> )
	desVar( "lrd1" <lrd1> )
	desVar( "wrdpg" <wrdpg>   )
	desVar( "lrdpg" <lrdpg>   )
	desVar(   "numBanks" <numBanks>)
	desVar("ldef" <ldef>)
	desVar("wdef" <wdef>)
	desVar("tper" <tper>)
	desVar("trf" <trf>)
	desVar("tdly" <tdly>)
	desVar("cbl" <cbl>)
	desVar("cwl" <cwl>)
	desVar("cg" <cg>)
	desVar("ws" <ws>)
	desVar("wnio" 10*<wdef>) 
	desVar("pvdd" VDD    )

	temp( <temp> )
	option( 'reltol <reltol> 'gmin <gmin>)
	desVar("NR" rows)
	desVar("colMux" colMux-1) ;unused if col-mux is 1

	desVar("twl" <tper>/2)
	analysis('tran ?start 0 ?stop 1.1*<tper> ?step 0.01n ?strobeperiod 0.001n ?errpreset 'moderate)
	run()

	; time required for given bitline differential, tper should be sufficiently large
	selectResults('tran)
	if( bcType=="6T" then
		dly_bldis = cross(v("BL") VDD-<BL_DIFF> 1 'falling) - cross(v("WLA") VDD/2 1 'rising)
	else
		dly_bldis = cross(v("RBL") VDD-<BL_DIFF> 1 'falling) - cross(v("WLA") VDD/2 1 'rising)
	)

	; run analysis with wl width just enough for given bitline differential
	desVar("twl" dly_bldis)
	analysis('tran ?start 0 ?stop 1.1*<tper> ?step 0.01n ?strobeperiod 0.001n ?errpreset 'moderate)
	run()

	;; measure power - all columns discharge doing either dummy read or full read.
	selectResults('tran)
	avg_pwr_r = average(getData("ICOL1.ICDA:pwr"))
	avg_pwrbc_r = average(getData("ICOL1.IBCA:pwr"))
	avg_pwr_pch_buf= average(getData("IPCH:pwr"))

	if( bcType=="6T" then	
		dly_pch_r=cross(v("BL") VDD*.95 1 'rising) - cross(v("PCH") VDD/2 1 'falling)
	else
		dly_pch_r=cross(v("RBL") VDD*.95 1 'rising) - cross(v("PCH") VDD/2 1 'falling)
	)

	if( colMux>1 then
		avg_pwr_hs = average(getData("ICOLD.ICDA:pwr"))
		avg_pwrbc_hs = average(getData("ICOLD.IBCA:pwr"))
	else
		avg_pwr_hs = 0
		avg_pwrbc_hs = 0
	)
	
	energycd_r = <ws>*(avg_pwr_r+avg_pwr_hs)*1.1*<tper>
	energybc_r = <ws>*(avg_pwrbc_r+avg_pwrbc_hs)*1.1*<tper>
	energy_inter_r=1.1*<tper>*avg_pwr_pch_buf
	dly_inter_r=cross(v("PCH") VDD*.95 1 'rising) - cross(v("PCH_IN") VDD/2 1 'rising)

	;; write data to file
	fprintf(of,"%d\t%d\t%d\t%e\t%e\t%e\t%e\t%e\t%e\n", <numBanks>, rows, colMux, dly_bldis, dly_pch_r, energycd_r, energybc_r, energy_inter_r,dly_inter_r)
	rows = rows*rowStep
	drain(of)
)
close(of)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Write calculations

;; open file for writing characterization results
of = outfile("dataw.txt","w")

;reinitialize rows 
if( char == 1 then
	rows = 16
else
	rows = <NR_sweep>
)

;; sweep rows
while( (rows <= maxRows)

	colMux = <colMux>
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
	desVar( "WLOffset" <WLOffset> )
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
	avg_pwr_writeDriver = average(getData("IWRD:pwr"))+average(getData("IWRDB:pwr"))
	avg_pwr_int_w=average(getData("IWEN:pwr"))+average(getData("IPCH:pwr"))
	avg_pwr_w = average(getData("ICOL1.ICDA:pwr"))
	
	
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
	energy_inter_w=avg_pwr_int_w*1.1*<tper>
	delay_inter_w=cross(v("WEN") VDD*.05 1 'rising) - cross(v("WEN_IN") VDD/2 1 'rising)

	;; write data to file
	fprintf(of,"%d\t%d\t%d\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\n", <numBanks>, rows, colMux, dly_bl_pch, dly_writeDriver, dly_bcwr, energycd_w, energybc_w, energy_writeDriver, energy_inter_w, delay_inter_w)
	rows = rows*rowStep
	drain(of)
)
close(of)

