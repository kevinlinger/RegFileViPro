;; TEST to find the gate capacitance of the WL transistors. Outputs value in the file cap.txt

;of = outfile( "data.txt" "w" ) 

;; set simulator
simulator( 'spectre)

design( "netlist" )

;; set model lists
modelFile(
     '("<include>")
     '("<subN>")
     '("<subP>")
)

    desVar(       "wpu" <wpu>)
    desVar(       "lpu" <lpu>    )
    desVar(       "wpd" <wpd>)
    desVar(       "lpd" <lpd>    )

 
    desVar(	  "wp1" <wp1>)
    desVar(	  "lp1" <lp1>	)
    desVar(	  "wp2" <wp2>	)
    desVar(	  "lp2" <lp2>	)
    desVar(	  "wn1" <wn1>	)
    desVar(	  "ln1" <ln1>	)
    desVar(	  "wn2" <wn2>	)
    desVar(	  "ln2" <ln2>	)

    desVar(   "pvddl" <pvddl>    )
    desVar(   "pvddh" <pvddh>    )

    temp( 25 )

    analysis('tran ?start 0 ?stop 2n ?step 0.01n ?strobeperiod 0.001n ?errpreset 'conservative)
  
    option( 'reltol 1e-6 'gmin 1e-12 )
    save( 'all)
    run()

    ;; calculate the capacitance
    selectResults('tran)
    ;pwr = average(getData(":pwr"))
    ;egy = 2*pwr*1e-9
    ;dly = cross(v("IOB") 0.5 1 'falling) - cross(v("SAEN") 0.5 1 'rising)
    ;fprintf(of,"%e\t%e\n",egy, dly)
    ;close(of)
