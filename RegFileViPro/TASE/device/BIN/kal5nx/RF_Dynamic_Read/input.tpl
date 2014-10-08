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
desVar(   "prise" <trf> )
desVar(   "pfall" <trf> )
desVar(	  "per" <tper> )
desVar(	  "ws"  <ws>   )
desVar(   "readPorts" <readPorts> )
desVar(   "writePorts" <writePorts> )
desVar(   "capacity" (<memsize>/<ws>) )


desVar(   "wkeepgbl" 1)
desVar(   "pullwlbl" 5)
desVar(   "pullwgbl" 5)
desVar(   "prewlbl" 3)
desVar(   "prewgbl" 3)
desVar(   "wkeeplbl" 1)



desVar( "gblnum" pow(2 <gblNumDynamic>))
desVar( "lblnum" pow(2 <lblNumDynamic>))

pvdd = <pvdd>


analysis('tran ?start 0 ?stop (<tper>*4) ?step 0.1p ?errpreset 'conservative)
temp(27)
option('reltol 1e-6 'gmin 1e-22)
save('all)
run()
selectResults('tran)


teval = cross(v("Dout") (pvdd/2.0) 1 'rising) - cross(v("In2") (pvdd/2.0) 1 'rising)
tpre1 = cross(v("Out") (pvdd/2.0) 1 'rising)  - cross(v("In2") (pvdd/2.0) 1 'falling)
tpre2 = cross(v("GBLout") (pvdd/2.0) 1 'rising)  - cross(v("In2") (pvdd/2.0) 1 'falling)

tdel = max(teval tpre1 tpre2)
;tdel = teval

Oldenergy = integ(i("Vvdd.p") 0.01n (<tper>*2))

energy = integ(i("Vvdd.p") <tper> (<tper> + tdel)) + integ(i("Vvdd.p") (<tper>*1.5) ((<tper>*1.5) + tdel)) + integ(i("Vvdd.p") (<tper>*3.0) ((<tper>*3.0) + tdel)) + integ(i("Vvdd.p") (<tper>*3.5) ((<tper>*3.5) + tdel))

avgenergy = energy/2.0


fprintf(outputFile "%e\n", tdel)
fprintf(outputFile "%e\n", (avgenergy*-1.0*<readPorts>*<ws>))
fprintf(outputFile "%e\n", (energy*-1.0*<readPorts>*<ws>))
close( outputFile ) 
