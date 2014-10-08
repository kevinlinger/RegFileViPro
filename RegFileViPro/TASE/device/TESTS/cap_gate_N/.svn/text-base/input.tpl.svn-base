;; TEST to find the gate capacitance of the WL transistors. Outputs value in the file cap.txt

of = outfile( "cap.txt" "w" ) 

;; set simulator
simulator( 'spectre)

design( "netlist" )

;; set model lists
    modelFile(
        '("<include>")
        '("<subN>")
        '("<subP>")
    )

;;setting vdd
    VDD = 1.0
    
    desVar("ldef" <ldef>)
    desVar("wdef" <wdef>)
    desVar("pvdd" <pvdd>)
    desVar("pvbp" <pvdd>)

    temp( <temp> )

    analysis('tran ?start 0 ?stop 1n ?step 0.01n ?strobeperiod 0.001n ?errpreset 'conservative)
  
    option( 'reltol 1e-6 'gmin <gmin> )
    save('all)
    run()

    ;; calculate the capacitance
    selectResults('tran)
    rt = cross( v( "WLM" ) 0.5 1 'rising )
    ;; finding the mid way point : since VDD = 1V, 1V - e^-t/RC = 0.5V
    rf = rt - 1e-12
    ;; pulse starts rising after 1ps
    fcap = rf/693.15
    ;; solving for C, since R = 1k, 1/2 = e^-t/RC => C = -t/(R*ln(1/2))
    ;; R*ln1/2 = 693.15
    fprintf( of "%e\n" fcap)
    close( of )
