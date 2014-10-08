simulator( 'spectre )
dir = "./"
design(  "./netlist")

    modelFile(
        '("<include>")
        '("<subN>")
        '("<subP>")
    )

resultsDir( "./OUT" )

desVar("pvin" 0)
desVar("wdef" <wdef>)
desVar("ldef" <ldef>)
desVar("pvdd" <pvdd>)
VDD = <pvdd>

analysis('dc ?param "pvin" ?start 0 ?stop VDD)

option( 'reltol 1e-6 'gmin <gmin> )
temp( <temp> )
save('all)

run()

selectResults( 'dc )
htol=cross(v("OUT") 0.5 1 'either)

analysis('dc ?param "pvin" ?start VDD ?stop "0")
option( 'reltol 1e-6 'gmin <gmin> )
temp( <temp> )
save('all)

run()

selectResults( 'dc )
ltoh=cross(v("OUT") 0.5 1 'either)

fout=outfile("data.txt","w")
fprintf(fout, "%f\t%f\n", htol,ltoh)
close(fout)
