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

analysis('tran ?stop 8n ?errpreset "moderate" )

option( 'reltol 1e-6 'gmin <gmin> )
temp( <temp> )
save('all)

run()
selectResult('tran)
