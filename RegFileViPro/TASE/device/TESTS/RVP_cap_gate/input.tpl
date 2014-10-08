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

;;setting vdd
    VDD = <pvdd>
    
    desVar(	  "wpu" <wpu>)
    desVar(	  "lpu" <lpu>	)
    desVar(	  "wpd" <wpd>	)
    desVar(	  "lpd" <lpd>	)
    desVar(	  "wpg" <wpg>	)
    desVar(	  "lpg" <lpg>	)

    desVar(   "ldef" <ldef>)
    desVar(   "wcap" <wcap> )
    desVar(   "pvdd" VDD    )
    desVar(   "pvbp" VDD    )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )
    desVar(   "pvin" 0    )
    desVar(   "pres" <pres>)

    temp( 25 )

    analysis('tran ?start 0 ?stop 1n ?step 0.01n ?strobeperiod 0.001n ?errpreset 'conservative)
  
    option( 'reltol 1e-6 'gmin 1e-12 )
    save( 'all)
    run()

    ;; calculate the capacitance
    selectResults('tran)
    rt = cross( v( "WLM" ) 0.5 1 'rising )
    ;; finding the mid way point : since VDD = 1V, 1V - e^-t/RC = 0.5V
    rf = rt - 1e-12
    res = <pres>
    ;; pulse starts rising after 1ps
    fcap = rf/res*ln(2)
    ;; solving for C, since R = 1k, 1/2 = e^-t/RC => C = -t/(R*ln(1/2))
    ;; R*ln1/2 = 693.15
    wcap = <wcap>*1e6
    fprintf( of "%e" fcap/wcap)
    close(of)
