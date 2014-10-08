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
desVar( "colMux" <colMux>)
desVar( "numBanks" <numBanks>)
VDD=<pvdd>

char = <char>

if( (<numBanks> == 1) then
fprintf(out,"%d\t%d\t%d\t%d\t%d\t%d\n",<numBanks>,<colMux>,0,0,0,0)
close(out)
else

		analysis('tran ?start 0 ?stop 1.25*1e-9 ?step 0.01n ?strobeperiod 0.001n ?errpreset 'conservative)
		temp(25)
		option('reltol 1e-6 'gmin 1e-22)
		save('all)
		run()
		selectResults('tran)
	
		
	
		interCon_energy = 1.25*1e-9*(average(getData("IBANK_SEL0:pwr"))+average(getData("IBANK_SELB0:pwr")))
		e_Tri_ivn = 1.25*1e-9*average(getData("Tri_state0:pwr"))*<ws>
		
			
		;;propagation delay through buffer chain to output tristate
		interCon_delay=cross(v("BANK_SEL_OUT0") VDD/2 1 'rising) -cross(v("BANK_SEL0") VDD/2 1 'rising)
		;; propagation delay from tristate to DFF over bank interconnect
		bank_output_delay= cross(v("DATA_OUT0") VDD/2 1 'rising) -cross(v("BANK_SEL_OUT0") VDD/2 1 'rising)

	fprintf(out,"%d\t%d\t%e\t%e\t%e\t%e\n", <numBanks>,<colMux>, e_Tri_ivn, bank_output_delay, interCon_energy, interCon_delay)

close(out)
)
