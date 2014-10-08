;; POWER-DELAY CHARACTERIZATION OF IO
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

;; Copy WRITE netlist

cpnetlist = "cp -f ./WRITE/netlist_mult netlist"
sh( cpnetlist )
design(  "./netlist")

resultsDir("./OUTW")

;; setting vdd and wdef
VDD = <pvdd>
wdef = <wdef>

desVar(	  "wpu" <wpu>	)
desVar(	  "lpu" <lpu>	)
desVar(	  "wpd" <wpd>	)
desVar(	  "lpd" <lpd>	)
desVar(	  "wpg" <wpg>	)
desVar(	  "lpg" <lpg>	)

desVar("ldef" <ldef>)
desVar("wdef" <wdef>)
desVar("tper" <tper>)
desVar("trf" <trf>)
desVar("twl" <tper>/2)
desVar("tdly" <tdly>)
desVar("cbl" <cbl>)
desVar("pvdd" VDD    )
desVar("NR" 128)	;SA and IO power/delay is independent of NR. Arbitrary choice of 128
desVar("mux" 3)
desVar("pvdd" VDD    )

temp( <temp> )
option( 'reltol <reltol> 'gmin <gmin>)

;; open file for writing characterization results
of = outfile("dataw.txt","w")

; reduce the loops to a single iteration if only getting metrics for a particular configuration
char = <char>
if( char == 1 then
        multList = '(2 4 8 16 24 32 40)
        minVdd = 0.6*<pvdd>
else
        multList = '(12)
        minVdd = <pvdd>
)

;sweep IO PD width
foreach(mult multList

 	desVar("wnio" mult*<wdef>)
	analysis('tran ?start 0 ?stop <tper> ?step 0.01n ?strobeperiod 0.001n ?errpreset 'conservative)
	run()

	;; measure power
	selectResults('tran)
	avg_pwr = average(getData("IIO:pwr"))
	energy = avg_pwr*<tper>
	etot_w = energy*<ws>

	;; measure delays

	; DFF delay 
	dly_ff = cross(v("IIO.db") VDD/2 1 'falling) - cross(v("CLK") VDD/2 1 'rising) 

	; Delay through tri-state when WEN goes high and enables it
	;dly_logic = cross(v("NRDWR") VDD/2 1 'falling) - cross(v("WEN") VDD/2 1 'rising)

	;; write data to file
	fprintf(of,"%d\t%e\t%e\n",mult,dly_ff,etot_w)
	drain(of)
)
close(of)

;; Copy READ netlist

cpnetlist = "cp -f ./READ/netlist_mult netlist"
sh( cpnetlist )
design(  "./netlist")
resultsDir("./OUTR")

VDD = <pvdd>
desVar(   "wpu" <wpu>   )
desVar(   "lpu" <lpu>   )
desVar(   "wpd" <wpd>   )
desVar(   "lpd" <lpd>   )
desVar(   "wpg" <wpg>   )
desVar(   "lpg" <lpg>   )

desVar("ldef" <ldef>)
desVar("wdef" <wdef>)
desVar("tper" <tper>)
desVar("trf" <trf>)
desVar("twl"  <tper>/2)
desVar("tdly" <tdly>)
desVar("cbl" <cbl>)
desVar("pvdd" VDD    )
desVar("NR" 128)
desVar("mux" 3)

temp( <temp> )
option( 'reltol <reltol> 'gmin <gmin>)

;; open file for writing characterization results
of = outfile("datar.txt","w")

;sweep IO PD width
foreach(mult multList

 	desVar("wnio" mult*<wdef>)
	analysis('tran ?start 0 ?stop <tper> ?step 0.01n ?strobeperiod 0.001n ?errpreset 'conservative)
	run()

	; time required for given bitline differential
	selectResults('tran)
	dly_bldis = cross(v("BL") 0.85*VDD 1 'falling) - cross(v("WLA") VDD/2 1 'rising)

	; run analysis with wl width just enough for given bitline differential
	desVar("twl" dly_bldis)
	analysis('tran ?start 0 ?stop <tper> ?step 0.01n ?strobeperiod 0.001n ?errpreset 'conservative)
	run()

	;; measure power
	selectResults('tran)
	avg_pwr = average(getData("IIO:pwr"))
	energy = avg_pwr*<tper>
	etot_r = energy*<ws>

	;; measure delays

	; DFF delay
	dly_out = cross(v("DOUT") VDD/2 1 'rising) - cross(v("CLK") VDD/2 1 'rising)

	;; write data to file
	fprintf(of,"%d\t%e\t%e\n",mult,dly_out,etot_r)
	drain(of)
)
close(of)
