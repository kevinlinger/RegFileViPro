;; POWER-DELAY CHARACTERIZATION OF WLDRIVER8
;; Satya Nalam 03-11-2010

;; set simulator
simulator( 'spectre)

design( "netlist" )

;; set model lists
modelFile(
     '("<include>")
     '("<subN>")
     '("<subP>")
)

;setting vdd and wdef
VDD = <pvdd>
wdef = <wdef>
    
desVar("ldef" <ldef>)
desVar("wdef" <wdef>)
desVar("cwl" <cwl>)
desVar("pvdd" VDD    )
desVar("wp_inv" <wdef>)
desVar("prise" <prise>)
desVar("pfall" <pfall>)
desVar("wlwidth" <wlwidth>)

; only need to optimize rising edge speed, so keep this min size.
desVar("wn_inv" <wdef>)

;  only need to optimize falling edge speed, so min size.
desVar("wp_nand" 2*<wdef>) 
    
desVar("wn_nand" <wdef>)

; not including and gate in the optimization, so keep fixed
desVar("wp1_and" 2*<wdef>)
desVar("wn1_and" <wdef>)
desVar("wp2_and" 4*<wdef>)
desVar("wn2_and" 2*<wdef>)

temp( <temp> )

; sweep wp_inv, wn_nand and number of cols
foreach( cols '(<NC_sweep>)

 ;open file for writing characterization results
 fname = sprintf(nil "data%d.txt" cols)
 of = outfile(fname,"w")

 ;print col header
 fprintf(of,"0\t\t")
 for( j <wnand_start> <wnand_stop>
  fprintf(of,"%e\t0\t\t0\t\t0\t\t" j*wdef)
 )
 fprintf(of,"\n")

 ;wp_inv sweep
 for( i <winv_start> <winv_stop>
  
  ;print row header
  fprintf(of,"%e\t",i*wdef)

  ;wn_nand sweep
  for( j <wnand_start> <wnand_stop>
	
	desVar("wp_inv" i*wdef)
	desVar("wn_nand" j*wdef)
	desVar("NC" cols)

	analysis('tran ?start 0 ?stop 1.25*<wlwidth> ?step 0.01n ?strobeperiod 0.001n ?errpreset 'conservative)

	option( 'reltol 1e-6 'gmin 1e-12 )
	save( 'all)
	run()

	;; calculate average power, peak power, and delay for WL driver
	selectResults('tran)
	avg_pwr = average(getData("I1:pwr") + getData("I5:pwr") + getData("I0:pwr"))
	pk_pwr = ymax(getData("I1:pwr") + getData("I5:pwr") + getData("I0:pwr"))
	dly = cross(v("WL") <pvdd>/2 1 'rising) - cross(v("A") <pvdd>/2 1 'rising)
	trise = cross(v("WL") 0.9*<pvdd> 1 'rising) - cross(v("WL") 0.1*<pvdd> 1 'rising)

	fprintf(of,"%e\t%e\t%e\t%e\t",avg_pwr,pk_pwr,dly,trise)
  )
  fprintf(of,"\n")
 )
 close(of)
)
