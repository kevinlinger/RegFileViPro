;; TEST to find the gate capacitance of the WL transistors. Outputs value in the file cap.txt

of = outfile( "data.txt" "w" ) 

;; set simulator
simulator( 'spectre)

design( "netlist" )

;; set model lists
modelFile(
     '("<include>")
     '("<subN>")
     '("<subP>")
)

    desVar(       "wpul" <wpul>)
    desVar(       "lpul" <lpul>    )
    desVar(       "wpdl" <wpdl>)
    desVar(       "lpdl" <lpdl>    )

    desVar(       "wpmux" <wpmux>)
    desVar(       "lpmux" <lpmux>    )
    desVar(       "wnmux" <wnmux>)
    desVar(       "lnmux" <lnmux>    )
 
    desVar(	  "wp1" <wp1>)
    desVar(	  "lp1" <lp1>	)
    desVar(	  "wp2" <wp2>	)
    desVar(	  "lp2" <lp2>	)
    desVar(	  "wn1" <wn1>	)
    desVar(	  "ln1" <ln1>	)
    desVar(	  "wn2" <wn2>	)
    desVar(	  "ln2" <ln2>	)

    desVar(       "wpt" <wpt>)
    desVar(       "lpt" <lpt>    )
    desVar(       "wnt" <wnt>)
    desVar(       "lnt" <lnt>    )

    desVar(   "pvdd" <pvdd>    )
    desVar(   "pvddh" <pvddh>    )

    temp( 25 )

    analysis('tran ?start 0 ?stop 2n ?step 0.01n ?strobeperiod 0.001n ?errpreset 'conservative)
  
    option( 'reltol 1e-6 'gmin 1e-12 )
    save( 'all)
    run()

    selectResults('tran)
    dly = cross(v("OUT") 0.5 1 'rising) - cross(v("DECOUT") 0.5 1 'rising)
    pwr = average(getData(":pwr"))
    egy = pwr*2e-9

    fprintf(of,"%e\t%e\n",egy, dly)
    close(of)
