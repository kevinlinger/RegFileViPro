;; set simulator
simulator( 'spectre)
clearAll()

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
   ;;resitance per micron from PTM
   resi = 0.488
   
   ;; N= number of rows
   ;; M = number of columns

resultsDir(   sprintf(s "./OUT/maxI.txt"))
   of = outfile(s,"w")

   foreach( N '(64 128 256 512 1024)
   ;;N = 256
   ;;foreach( M '( 8 16 32 64 128)
   M = 2**18/(16*N)
    
    when(N == 64 PulseW = 0e-9 stTime = PulseW + 0.45n)
    when(N == 128 PulseW = 0.05e-9 stTime = PulseW + 0.45n)
    when(N == 256 PulseW = 0.1e-9 stTime = PulseW + 0.5n)
    when(N == 512 PulseW = 0.32e-9 stTime = PulseW + 0.55n)
    when(N == 1024 PulseW = 0.6e-9 stTime = PulseW + 0.8n)

    desVar( "dt" PulseW )
    desVar( "rows" N-2 )
    desVar( "columns" M-8)

    ;;designate capacitance and resistance 
    desVar( "cap" capa*N)
    desVar("res" resi*0.8*N)

    temp( 25 )


    ;;output file
resultsDir(sprintf(outputFile "./OUT/delayRows%d.txt" N))
    out = outfile(outputFile, "w")

    analysis('tran ?start 0 ?stop stTime ?step 0.01n ?errpreset 'conservative)    option( 'reltol 1e-6 'gmin 1e-12 )
    save( "C0.Col0" )
    run()
       
    selectResults('tran) 
    max = peakToPeak(i("C0.Col0.Ip:in"));
    maxB = peakToPeak(i("C0.Col0.IpB:in"));

   ;;plot control signals
   ;;plot(v("Pre") v("WL0") v("Csel"))
   ;;plot  voltage of BL, BLB
   plot(  v("C0.Col0.BL") v("C0.Col0.BLB") v("C0.Col0.BL4") v("C0.Col0.BLB4") )


   ;;plot(i("C0.Col0.Ip:in") i("C0.Col0.IpB:in"))
   addSubwindow()

   ;;plot current
   ;;plot(i("C0.Col0.Dummy.N1.NX:d") i("C0.Col0.Cell1.N4.NX:d"))

   ;;print voltage and current to file
   setup(?numberNotation 'scientific)
   fprintf(of "%d %e %e\n" N,max,maxB)

   ocnPrint(?output out v("C0.Col0.BL") v("C0.Col0.BLB") v("C0.Col0.BL4") v("C0.Col0.BLB4"))
   ; getData("C0.Col0.Cell1:pwr"))
)




