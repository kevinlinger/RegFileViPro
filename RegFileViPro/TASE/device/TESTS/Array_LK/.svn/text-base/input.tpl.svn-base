;; set simulator
simulator( 'spectre)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
    desVar(	  "lpg" <lpg>	)

    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd" <pvdd>    )
    desVar(   "pvbp" <pvdd>    )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )
    desVar(   "pvin" 0    )
   ;;define capacitance value per 0.8um => bet each cells
   capa = 0.180E-15



;;output file1
resultsDir(sprintf(s "./OUT/Ave.txt"))
of = outfile(s, "w")

;; N= number of rows
   ;; M = number of columns

   foreach( N '(64 128 256 512 1024)
   ;;N = 256
   ;;foreach( M '( 8 16 32 64 128)
   M = 2**18/(16*N)

    PulseW = 0.6e-9
    stTime = PulseW + 0.8n

    desVar( "dt" PulseW )
    desVar( "rows" N-2 )
    desVar( "columns" M-2)

    ;;designate capacitance 
    desVar( "cap" capa*N )


    temp( 25 )

    analysis('tran ?start 0 ?stop stTime ?step 0.01n ?errpreset 'conservative) 

    option( 'reltol 1e-6 'gmin 1e-12 )
    save( "C0.Col0" )
    run()
       
    selectResults('tran) 

    plot( getData("C0:pwr") getData("C0.Col0:pwr")*M getData("C0.Col0.Cell1:pwr")*M*N getData("C0.DumCol:pwr")*M*N/(M-2))
addSubwindow()     

 Tot = average(getData("C0:pwr"))
 Sum = average(getData("C0.Col0:pwr"))*M


   ;;print voltage and current to file
   setup(?numberNotation 'scientific)
   fprintf(of "%d %d %e %e \n" M, N, Tot, Sum )

)





