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
    
    desVar(	  "wpu" <wpu>	)
    desVar(	  "lpu" <lpu>	)
    desVar(	  "wpd" <wpd>	)
    desVar(	  "lpd" <lpd>	)
    desVar(	  "wpg" <wpg>	)
    desVar(	  "lpg" <lpd>	)

    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd" VDD    )
    desVar(   "pvbp" VDD    )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )
    desVar(   "pvin" 0    )
    
    R = 1000
    desVar( "pres" R )
    
    temp( 25 )

    analysis('tran ?start 0 ?stop 10p ?step 0.01p ?strobeperiod 0.001p ?errpreset 'conservative)
  
    option( 'reltol 1e-6 'gmin 1e-12 )
    save( 'all)
    run()

    ;; calculate the capacitance
    selectResult('tran)
    rHH = cross( v( "BL1" ) 0.5 1 'falling )
    rHL = cross( v( "BL2" ) 0.5 1 'falling )
    rLL = cross( v( "BL3" ) 0.5 1 'falling )
    rLH = cross( v( "BL4" ) 0.5 1 'falling )

    ;; finding the mid way point : since VDD = 1V, 1V - e^-t/RC = 0.5V
    rf1 = rHH - 1e-12 
    rf2 = rHL - 1e-12 
    rf3 = rLL - 1e-12 
    rf4 = rLH - 1e-12     
    ;; pulse starts falling after 1ps


    fcap1 = -rf1/(R*ln(0.5))
    fcap2 = -rf2/(R*ln(0.5))
    fcap3 = -rf3/(R*ln(0.5))
    fcap4 = -rf4/(R*ln(0.5))

    ;; solving for C, 1/2 = e^-t/RC => C = -t/(R*ln(1/2)
    fprintf( of " WL = VDD, data = VDD C = %e F\n WL = VDD, data = 0 C = %e F\n WL = 0, data = 0 C = %e F\n WL = 0, data = VDD C = %e F\n", fcap1, fcap2, fcap3, fcap4)
    close( of )













