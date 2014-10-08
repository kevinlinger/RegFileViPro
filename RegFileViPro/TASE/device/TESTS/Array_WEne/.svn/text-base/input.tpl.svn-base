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
   
   ;; N= number of rows
   ;; M = number of columns


    foreach( N '(64 128 256 512 1024)
    ;;N = 512
    ;;foreach( M '(16 32 64 128)
    M = 2**18/(N*16)

    when( N == 64 PW=0.2n stTime= PW+0.35n)
    when( N == 128 PW=0.3n stTime= PW+0.35n)
    when( N == 256 PW=0.6n stTime= PW+0.4n)
    when( N == 512 PW=1.2n stTime= PW+0.5n)
    when( N == 1024 PW=2.1n stTime= PW+0.8n)

    desVar( "rows" N-2 )
    desVar( "columns" M-9)
    desVar( "Pwi" PW) 
    ;;designate capacitance 
    desVar( "cap" capa*N )


    temp( 25 )


    ;;output file
   resultsDir( sprintf(outputFile "./OUT/powerW%d.txt" N))
    out = outfile(outputFile, "w")
    
   resultsDir( sprintf(s "./OUT/powerR%d.txt" N))
    of = outfile(s,"w")

    analysis('tran ?start 0 ?stop stTime ?step 0.01n ?strobeperiod 0.01n ?errpreset 'conservative) 

    option( 'reltol 1e-6 'gmin 1e-12 )
    save( "C0.Col0" )
    run()
       
    selectResults('tran)

   setup(?numberNotation 'scientific)
   ocnPrint(?output out v("C0.Col0.BL") i("C0.Col0.Ip:in") v("C0.Col0.BLB") i("C0.Col0.IpB:in") getData("C0.Col0:pwr"))

;;print the read lines
      ocnPrint(?output of v("C0.ColR.BL") i("C0.ColR.Dummy.N1.NX:s") getData(":pwr") v("C0.ColR.BLB") i("C0.ColR.Cell1.N4.NX:d") getData("C0.ColR:pwr"))

 )



