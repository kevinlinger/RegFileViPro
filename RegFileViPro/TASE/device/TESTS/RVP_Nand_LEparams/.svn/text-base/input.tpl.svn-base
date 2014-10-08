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

;in = infile("../RVP_Inv_LEparams/data.txt")
;fscanf(in, "%f %f", tau, p)
out = outfile("delay.txt", "w")

for( i 2 8
	desVar( "f" i)

	analysis('tran ?start 0 ?stop 4*<pwidth> ?step 0.002*<pwidth> ?errpreset 'conservative)
	temp(<temp>)
	option('reltol 1e-6 'gmin <gmin>)
	save('all)
	run()
	selectResults('tran)

	tpHL = cross(v("OUT") <pvdd>/2 1 'falling) - cross(v("IN") <pvdd>/2 1 'rising)
	tpLH = cross(v("OUT") <pvdd>/2 1 'rising) - cross(v("IN") <pvdd>/2 1 'falling)

	fprintf(out "%d\t%e\n" i,(tpHL+tpLH)/2e-12)
)

close(out)
;close(in)
