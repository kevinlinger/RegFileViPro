/*
 Ocean script to measure inverter chain energy
 
 Author		Satya
 Date		04/17/2011
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

out = outfile("data.txt", "w")

desVar(   "pvdd" <pvdd>)
desVar(   "pvbp" <pvdd>)
desVar(   "ldef" <ldef> )
desVar(   "wdef" <wdef> )
desVar(   "prise" <prise> )
desVar(   "pfall" <pfall> )
desVar(   "pwidth" <pwidth> )
desVar(   "ws" <ws> )
desVar(   "cwl" <cwl>)
desVar(   "cg" <cg>)

char = <char>

if( char == 1 then
	for( i 0 3
		analysis('tran ?start 0 ?stop 1.25*<pwidth> ?step 0.01n ?strobeperiod 0.001n ?errpreset 'conservative)
		temp(<temp>)
		option('reltol 1e-6 'gmin <gmin>)
		save('all)
		run()
		selectResults('tran)
	
		e_CMUX = 1.25*<pwidth>*average(getData(sprintf(nil "ICMUX%d:pwr",i)))
		e_PCH = 1.25*<pwidth>*average(getData(sprintf(nil "IPCH%d:pwr",i)))
		e_SAPCH = 1.25*<pwidth>*average(getData(sprintf(nil "ISAPCH%d:pwr",i)))
		e_SAE = 1.25*<pwidth>*average(getData(sprintf(nil "ISAE%d:pwr",i)))	
		e_WEN = 1.25*<pwidth>*average(getData(sprintf(nil "IWEN%d:pwr",i)))

		fprintf(out,"%e\t%e\t%e\t%e\t%e\n",e_CMUX,e_PCH,e_SAPCH,e_SAE,e_WEN)
	)
else
	analysis('tran ?start 0 ?stop 1.25*<pwidth> ?step 0.01n ?strobeperiod 0.001n ?errpreset 'conservative)
	temp(<temp>)
	option('reltol 1e-6 'gmin <gmin>)
	save('all)
	run()
	selectResults('tran)
	
	i = <addrCol>
	
	e_CMUX = 1.25*<pwidth>*average(getData(sprintf(nil "ICMUX%d:pwr",i)))
	e_PCH = 1.25*<pwidth>*average(getData(sprintf(nil "IPCH%d:pwr",i)))
	e_SAPCH = 1.25*<pwidth>*average(getData(sprintf(nil "ISAPCH%d:pwr",i)))
	e_SAE = 1.25*<pwidth>*average(getData(sprintf(nil "ISAE%d:pwr",i)))	
	e_WEN = 1.25*<pwidth>*average(getData(sprintf(nil "IWEN%d:pwr",i)))

	fprintf(out,"%e\t%e\t%e\t%e\t%e\n",e_CMUX,e_PCH,e_SAPCH,e_SAE,e_WEN)
)
close(out)
