/*
 Ocean script to test robustness of dynamic OR gate
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
)

desVar(   "pvdd" <pvdd>)
desVar(   "pvbp" <pvdd>)
desVar(   "ldef" <ldef> )
desVar(   "wdef" <wdef> )
desVar(   "prise" 10e-12 )
desVar(   "pfall" 10e-12 )
desVar(	  "per" <tper> )
desVar(	  "ws"  <ws>   )
desVar(   "rows" <rows> )
desVar(   "readPorts" <readPorts> )
desVar(   "writePorts" <writePorts> )
desVar(   "capacity" (<memsize>/<ws>) )
desVar( "gblnum" pow(2 <gblNumStatic>))
desVar( "lblnum" pow(2 <lblNumStatic>))

pvdd = <pvdd>

desVar(   "lblnsize" 1)
desVar(   "lblpsize" 1)
desVar(   "gblnsize" 1)
desVar(   "gblpsize" 1)

analysis('tran ?start 0 ?stop (<tper>*4) ?step 0.1p ?errpreset 'conservative)
temp(27)
option('reltol 1e-6 'gmin 1e-22)
save('all)
ic("LBLout" 0)
run()
selectResults('tran)

tdel = cross(v("Dout") (pvdd/2.0) 1 'falling) - cross(v("C2") (pvdd/2.0) 1 'rising)
;Oldenergy = integ(i("Vvdd.p") 0.01n (<tper>*4))

energy = integ(i("Vvdd.p") <tper> (<tper> + tdel)) + integ(i("Vvdd.p") (<tper>*1.5) (<tper>*1.5 + tdel)) + integ(i("Vvdd.p") (<tper>*2) ((<tper>*2) + tdel)) + integ(i("Vvdd.p") (<tper>*2.5) ((<tper>*2.5) + tdel)) + integ(i("Vvdd.p") (<tper>*3) ((<tper>*3) + tdel)) + integ(i("Vvdd.p") (<tper>*3.5) ((<tper>*3.5) + tdel)) + integ(i("Vvdd.p") (<tper>*4) ((<tper>*4) + tdel)) + integ(i("Vvdd.p") (<tper>*4.5) ((<tper>*4.5) + tdel))

avgenergy = energy/4.0

;plot( v("C1") v("C2") v("C1Bar") v("C2Bar") v("In1") v("LBLout") v("GBLin") v("GBLout") v("Dout") ) 


fprintf(outputFile "%e\n", tdel)
fprintf(outputFile "%e\n", (avgenergy*-1*<readPorts>*<ws>))

close( outputFile ) 

