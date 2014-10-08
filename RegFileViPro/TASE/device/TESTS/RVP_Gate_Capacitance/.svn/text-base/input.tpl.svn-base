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

;;setting vdd
VDD = <pvdd>

desVar(   "ldef" <ldef>)
desVar(   "pvdd" VDD    )
desVar(   "pvbp" VDD    )
desVar(   "minl" <minl> )
desVar(   "minw" <minw> )
desVar(   "pvin" 0    )
desVar(   "prise" <prise> )
desVar(   "pfall" <pfall> )
desVar(   "pwidth" <pwidth> )

gcap = <gcap_start>
out = outfile("cap.txt", "w")

while( gcap < <gcap_stop>
	desVar(   "gcap" gcap)
	analysis('tran ?start 0 ?stop 4*<pwidth> ?step 0.002*<pwidth> ?errpreset 'conservative)
	temp(<temp>)
	option('reltol 1e-6 'gmin <gmin>)
	save('all)
	run()
	selectResults('tran)

	;fet
	tpHL1 = cross(v("OUT2") <pvdd>/2 1 'falling) - cross(v("OUT1") <pvdd>/2 1 'rising)
	tpLH1 = cross(v("OUT2") <pvdd>/2 1 'rising) - cross(v("OUT1") <pvdd>/2 1 'falling)
	t1 = (tpHL1 + tpLH1)/2

	;test cap
	tpHL2 = cross(v("OUT3") <pvdd>/2 1 'falling) - cross(v("OUT1") <pvdd>/2 1 'rising)
	tpLH2 = cross(v("OUT3") <pvdd>/2 1 'rising) - cross(v("OUT1") <pvdd>/2 1 'falling)
	t2 = (tpHL2 + tpLH2)/2

	fprintf(out "%e\t%e\t%e\n" gcap,t1,t2)
	gcap = gcap + <gcap_step>
)

close(out)
