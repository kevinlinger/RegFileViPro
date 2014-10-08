;; POWER-DELAY CHARACTERIZATION OF TIMING_PREDEC
;; Satya Nalam 03-11-2010

;; set simulator
simulator( 'spectre)
(envSetVal "spectre.opts" "multithread" 'string "on")
(envSetVal "spectre.opts" "nthreads" 'string "3")

design( "netlist" )
resultsDir("./OUT")

;; set model lists
modelFile(
     '("<include>")
     '("<subN>")
     '("<subP>")
)

;setting vdd and wdef
wdef = <wdef>
VDD = <pvdd>
    
desVar("ldef" <ldef>)
desVar("wdef" <wdef>)
desVar("tper" <tper>)
desVar("trf" <trf>)
desVar("ws" <ws>)
desVar("cg" <cg>)
desVar("cwl" <cwl>)
desVar("cbl" <cbl>)
desVar("wpch" 6*<wdef>)
desVar("wsapc" 5*<wdef>)
desVar("weql" <wdef>)
desVar("wen" <wdef>)
desVar("wncs" 6*<wdef>)
desVar("wpcs" 6*<wdef>)
desVar("pvdd" VDD)

;;No sweep here since only the constant component is being measured
;;Max values of NR and NC used. The capacitance stuff can probably be removed from the netlist to simplify this sim
desVar("NR" 512)
desVar("NC" 256)

temp( <temp> )

of = outfile("data.txt","w")

numWords = <memsize>/<ws>
rows = 512
mux = numWords/rows

desVar("mux" mux-1)

analysis('tran ?start 0 ?stop 2*<tper> ?step 0.1n ?strobeperiod 0.01n ?errpreset 'moderate)
run()
selectResult('tran)

;; measure power from the fixed portions of the timing block, the buffer chains are characterized separately
;; average power for one read and one write is being measured
;; For the nands/ands, two will switch in opposite directions while the others remain at 0 - hence the 2 and 6 multipliers
;; For the addresses, assuming the worst case of all address bits switching
;; Ignoring the power of min-sized buffer chains which are not of fixed length.

avg_pwr0 = average(getData("I0.ITMG.IDLY_WLEN_BChain2:pwr")+getData("I0.ITMG.IDLY_SAE_BChain:pwr")+getData("I0.ITMG.ITMNG_NOR0:pwr")+getData("I0.ITMG.ITMNG_NOR1:pwr")+getData("I0.ITMG.ITMNG_INV0:pwr")+getData("I0.ITMG.ITMNG_INV1:pwr")+getData("I0.ITMG.ITMNG_AND0:pwr")+getData("I0.ITMG.ITMNG_NAND2:pwr")+getData("I0.ITMG.ITMNG_NOR3:pwr")+getData("I0.ITMG.ITMNG_INV2:pwr")+getData("I0.ITMG.ITMNG_BUF0:pwr"))
avg_pwr1 = average(getData("I0.IColDec:pwr")+getData("I0.IWR:pwr")+12*getData("I0.IAR_0:pwr"))
avg_pwr2 = average(2*getData("I0.IANDCS_0:pwr")+2*getData("I0.INANDCSB_0:pwr")+6*getData("I0.IANDCS_1:pwr")+6*getData("I0.INANDCSB_1:pwr"))
avg_pwr3 = average(2*getData("I0.IBUFCSB2_0:pwr")+6*getData("I0.IBUFCSB2_1:pwr"))
avg_pwr = avg_pwr0+avg_pwr1+avg_pwr2+avg_pwr3
energy = 0.5*avg_pwr*2*<tper>
fprintf(of,"%e\n",energy)

close(of)
