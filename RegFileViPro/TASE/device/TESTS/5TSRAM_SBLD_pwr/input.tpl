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
desVar("pvddr" <pvddr>)
desVar("cbl" <cbl>)

desVar(    "wpu1" <wpu1>   )
desVar(    "lpu1" <lpu1>   )
desVar(    "wpu2" <wpu2>   )
desVar(    "lpu2" <lpu2>   )
desVar(    "wpd1" <wpd1>   )
desVar(    "lpd1" <lpd1>   )
desVar(    "wpd2" <wpd2>   )
desVar(    "lpd2" <lpd2>   )
desVar(    "wpg" <wpg>   )
desVar(    "lpg" <lpg>   )

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
 bldelay = cross(abs(v("BL2")-v("BL1")) <BLdiff> 1 'rising) - cross(v("WLA")<pvdd>/2 1 'rising)

 desVar("pw" bldelay)
 analysis('tran ?stop 2*<pw> ?errpreset "moderate" )
 save('all)
 run()
 selectResult('tran)

 ;measure WL to SA out delay and pwr
 power1 = average(getData("ISA:pwr"))
 power2 = average(getData(":pwr"))
 fprintf(of "%d\t%e\t%e\n" rows,power1,power2)
)

close(of)
