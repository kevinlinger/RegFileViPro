/*
 Ocean script to test write operation of register file with dynamic read periphery
*/

; ************************** main code ***************************
simulator( 'spectre )

;; COPY THE CORRISPONDING NETLIST FOR THE DESIRED DATA PATTERN
design( "./netlist" )

resultsDir("./OUT")
outputFile = outfile( "data.txt" "w" )

modelFile( 
	'("<include>")
	'("<subN>")
	'("<subP>")
        '("<subPU>")
        '("<subPD>")
        '("<subPG>")
)


desVar(	  "wpu" <bitcellUpsize>*<wpu>	)
desVar(	  "lpu" <lpu>	)
desVar(	  "wpd" <wpd>	)
desVar(	  "lpd" <lpd>	)
desVar(	  "wpg" <bitcellUpsize>*<wpg>	)
desVar(	  "lpg" <lpg>	)
desVar("twl" <tper>/6)
desVar("tdly" <tdly>)
desVar("cbl" <cbl>)
desVar("NR" <rows>)
desVar("cwl" <cwl>)
desVar("cg" <cg>)
desVar("numBanks" <numBanks>)
desVar(   "pvdd" <pvdd>)
desVar(   "pvbp" <pvdd>)
desVar(   "ldef" <ldef> )
desVar(   "wdef" <wdef> )
desVar(   "prise" <trf> )
desVar(   "pfall" <trf> )
desVar(	  "per" <tper> )
desVar(	  "ws"  <ws>   )
desVar(   "readPorts" <readPorts> )
desVar(	  "readPortsQ" <readPortsQ> )
desVar(   "readPortsQB" <readPortsQB> )
desVar(   "writePorts" <writePorts> )
desVar(   "pullDownWidth" <pullDownWidth> )
desVar(   "capacity" (<memsize>/<ws>) )

pvdd = <pvdd>


analysis('tran ?start 0 ?stop (<tper>*2) ?step 0.1p ?errpreset 'conservative)
temp(27)
option('reltol 1e-6 'gmin 1e-22)
save('all)
run()
selectResults('tran)


; Bitcell flip delay
tdel1 = cross(v("IBCA.Q") (pvdd/2.0) 1 'rising) - cross(v("WLA") (pvdd/2.0) 1 'rising)

; Bitline charge delay
tdel2 = cross(v("BL") (pvdd/2.0) 1 'rising) - cross(v("WENB") (pvdd/2.0) 1 'falling)

maxdel = max(tdel1 tdel2)

;energy = integ(i("VVDD.p") 5e-10 cross(v("BL") (pvdd*0.9) 1 'rising)) + integ(i("VVDD.p") (<tdly>+5e-10) cross(v("IBCA.Q") (pvdd/2.0) 1 'rising))

energy = integ(i("VVDD.p") 5e-10 (maxdel+5e-10)) + integ(i("VVDD.p") (<tdly>+5e-10) (<tdly>+5e-10+maxdel))

;plot(v("WLA") v("IBCA.Q") v("IBCA.QB") v("BL") v("BLB") v("DIN") )

fprintf(outputFile "%e\n", tdel1)
fprintf(outputFile "%e\n", tdel2)
fprintf(outputFile "%e\n", (energy*-1.0*<ws>*<writePorts>))
close( outputFile ) 
