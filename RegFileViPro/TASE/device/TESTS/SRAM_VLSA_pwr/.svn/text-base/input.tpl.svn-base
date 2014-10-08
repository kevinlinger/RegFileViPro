simulator( 'spectre )
dir = "./"
design(  "./netlist")

modelFile( 
        '("<include>")
        '("<subN>")
        '("<subP>")
        '("<subPU>")
        '("<subPD>")
        '("<subPG>")
    )

resultsDir( "./OUT" )

desVar("wdef" <wdef>)
desVar("win" <win>)
desVar("lin" <lin>)
desVar("ldef" <ldef>)
desVar("pvdd" <pvdd>)
desVar("cbl" <cbl>)
desVar(	  "wpu" <wpu>	)
desVar(	  "lpu" <lpu>	)
desVar(	  "wpd" <wpd>	)
desVar(	  "lpd" <lpd>	)
desVar(	  "wpg" <wpg>	)
desVar(	  "lpg" <lpg>	)
desVar(    "prf" <prf>)
desVar(    "pse" <pse>)
desVar(    "colmux" <colmux>-1)

of = outfile("data.txt","w")

foreach( rows '(<NR_sweep>) 

 desVar("numRows" rows)
 desVar("pw" <pw>)


 analysis('tran ?stop 2*<pw> ?errpreset "moderate" )

 option( 'reltol <reltol> 'gmin <gmin> )
 temp( <temp>)
 save('all)

 run()
 selectResult('tran)
 
 ;measure time for diff. development
 bldelay = cross(v("BLB")-v("BL") <BLdiff> 1 'rising) - cross(v("WLA") <pvdd>/2 1 'rising)

 desVar("pw" bldelay)
 analysis('tran ?stop 2*<pw> ?errpreset "moderate" )
 save('all)
 run()
 selectResult('tran)

 ;measure WL to SA out delay and pwr
 power1 = average(getData("ISA:pwr"))
 power2 = average(getData(":pwr"))
 delay = cross(v("OUT") <pvdd>/2 1 'falling) - cross(v("WLA") <pvdd>/2 1 'rising)
 fprintf(of "%d\t%e\t%e\n" rows,power1,power2)
)

close(of)
