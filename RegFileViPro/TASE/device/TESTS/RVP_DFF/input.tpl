; ************************** main code ***************************
simulator( 'spectre )

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
desVar(   "trf" <trf> )
desVar(   "tper" <tper> )
desVar(   "ws" <ws> )
desVar(   "cwl" <cwl> )
desVar(   "colMux" <colMux> )
desVar(   "numBanks" <numBanks> )

out = outfile("data.txt", "w")

analysis('tran ?start 0 ?stop 2*<tper> ?step 0.001*<tper> ?errpreset 'moderate)
temp(<temp>)
option('reltol 1e-6 'gmin <gmin>)
save('all)
run()
selectResults('tran)

tpHL1 = cross(v("Q1") <pvdd>/2 1 'falling) - cross(v("CLK") <pvdd>/2.0 1 'rising)
tpLH1 = cross(v("Q1") <pvdd>/2 1 'rising) - cross(v("CLK") <pvdd>/2.0 2 'rising)

tpHL2 = cross(v("Q2") <pvdd>/2 1 'falling) - cross(v("CLK") <pvdd>/2.0 1 'rising)
tpLH2 = cross(v("Q2") <pvdd>/2 1 'rising) - cross(v("CLK") <pvdd>/2.0 2 'rising)

;; input FF delay (addresses), this applies to both read and write
delay_FF= (tpHL1+tpLH1)/2
;; read energy- all input address bits + data out bits (=wordsize)
energy_r= 2*<tper>*average(getData("I1:pwr"))*(<ws>+<addrRow>+<addrCol>)

;; data in delay, only for write
delay_dataIn= (tpHL2+tpLH2)/2
;; energy for write- driving data_in bits + energy of address bits
energy_w=2*<tper>*average(getData("I2:pwr"))*<ws>+2*<tper>*average(getData("I1:pwr"))*(<addrRow>+<addrCol>)


fprintf(out, "%e\t%e\t%e\t%e\n", delay_FF, delay_dataIn, energy_r, energy_w)

close(out)
