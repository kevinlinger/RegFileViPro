;; set simulator
simulator( 'spectre)
clearAll()

;;define technology
tech = 90

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
   ;;define resistance per micron, from PTM website
   resi = 0.488

)

   
   ;; N= number of rows
   ;; M = number of columns


   ;;output file
   resultsDir( sprintf(s "./OUT/delayW.txt"))	
    of = outfile(s,"w")
 
    foreach( N '(64 128 256 512 1024)
    ;;N = 1024
    ;;foreach( M '(16 32 64 128)
    M = 2**18/(N*16)

    when( N == 64 PW=0.3n stTime= PW+0.35n)
    when( N == 128 PW=0.4n stTime= PW+0.35n)
    when( N == 256 PW=0.7n stTime= PW+0.4n)
    when( N == 512 PW=1.3n stTime= PW+0.5n)
    when( N == 1024 PW=2.4n stTime= PW+0.8n)

    desVar( "rows" N-2 )
    desVar( "columns" M-9)
    desVar( "Pwi" PW) 
    ;;designate capacitance and resistance
    
    desVar( "cap" capa*N )
    desVar( "res" resi*0.8*N )

    temp( 25 )

  resultsDir( sprintf(fof "./OUT/delayRows%d.txt" N))
   out = outfile(fof, "w")

    analysis('tran ?start 0 ?stop stTime ?step 0.01n ?strobeperiod 0.01n ?errpreset 'conservative) 

    option( 'reltol 1e-6 'gmin 1e-12 )
    save( 'all )
    run()
       
    selectResults('tran)

   TQ = cross(v("C0.Col0.Cell2.Q") 0.1 1 'falling)
   TQB= cross(v("C0.Col0.Cell2.QB") 0.9 1 'rising)


   setup(?numberNotation 'scientific)
   fprintf(of "%d %d %e %e\n" M, N, TQ, TQB)

   ocnPrint(?output out i("C0.Col0.Ip:in") i("C0.Col0.IpB:in") )


 )






