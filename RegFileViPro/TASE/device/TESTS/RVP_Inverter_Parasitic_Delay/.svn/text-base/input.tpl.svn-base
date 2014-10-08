/*
 Ocean script to measure inverter parasitic delay
 
 Author		Satya
 Date		10/22/2008
 Modified by
*/

; ************************** main code ***************************
simulator( 'spectre )

;; COPY THE CORRISPONDING NETLIST FOR THE DESIRED DATA PATTERN
design( "./netlist" )

resultsDir("./OUT")

modelFile( 
	'("<include>")
	'("<subN>")
	'("<subP>")
)

desVar(   "pvdd" <pvdd>)
desVar(   "pvbp" <pvdd>)
desVar(   "ldef" <ldef> )
desVar(   "wdef" <wdef> )
desVar(   "prise" <prise> )
desVar(   "pfall" <pfall> )
desVar(   "pwidth" <pwidth> )

analysis('tran ?start 0 ?stop 2*<pwidth> ?step 0.1p ?errpreset 'conservative)
temp(<temp>)
option('reltol 1e-6 'gmin <gmin>)
save('all)
run()
selectResults('tran)

tpHL = cross(v("OUT") 0.5 1 'falling) - cross(v("IN") 0.5 1 'rising)
tpLH = cross(v("OUT") 0.5 1 'rising) - cross(v("IN") 0.5 1 'falling)

out = outfile("data.txt", "w")
fprintf(out "%e" (tpHL+tpLH)/2)
close(out)
