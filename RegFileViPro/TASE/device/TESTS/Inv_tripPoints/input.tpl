simulator( 'spectre )
dir = "./"
design(  "./netlist")

    modelFile(
        '("<include>")
        '("<subN>")
        '("<subP>")
        '("<subPU>")
        '("<subPD>")
    )

resultsDir( "./OUT" )

desVar("pvin" 0)
desVar("wdef" <wdef>)
desVar("ldef" <ldef>)
desVar("wpu" <wpu>)
desVar("lpu" <lpu>)
desVar("wpd" <wpd>)
desVar("lpd" <lpd>)
desVar("pvdd" <pvdd>)
desVar(	  "vtpu"  0	)
desVar(	  "vtpd"  0	)
VDD = <pvdd>
x=-0.1
fout=outfile("datapu.txt","w")
while( x<=0.12
	analysis('dc ?param "pvin" ?start VDD ?stop 0)
	desVar(	  "vtpu"  x	)
	option( 'reltol 1e-6 'gmin <gmin> )
	temp( <temp> )
	save('all)

	run()

	selectResults( 'dc )
	htol=cross(v("OUT") 0.5 1 'either)
	
	
	fprintf(fout, "%f\t%f\n", htol,x)
	x=x+0.02
)
desVar("vtpu" 0)
close(fout)
fout=outfile("datapd.txt","w")
x=-0.1
while( x <= 0.12
	analysis('dc ?param "pvin" ?start 0 ?stop VDD)
	desVar(	  "vtpd"  x	)
	option( 'reltol 1e-6 'gmin <gmin> )
	temp( <temp> )
	save('all)

	run()

	selectResults( 'dc )
	htol=cross(v("OUT") 0.5 1 'either)
	
	
	fprintf(fout, "%f\t%f\n", htol,x)
	x=x+0.02
)
close(fout)
close(fout)
