/*
Ocean script to measure array energy, with different number of rows and columns. Number of bank and total array size is constant


Author: Sato Kiwamu

*/


;###################Main Code##############
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
    desVar(	  "lpg" <lpg>	)

    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd" <pvdd>    )
    desVar(   "pvbp" <pvdd>    )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )
    desVar(   "pvin" 0    )

   ;;define capacitance value per 0.8um => bet each cells
   ;;value taken from PTM website, for 90nm
   capa = 0.180E-15
   

   ;;Define number of rows and columns, total size of array => 2^18b
   ;; N= number of rows
   ;; M = number of columns
   foreach( N '(64 128 256 512 1024)
   ;;N = 256
   M = 2**18/(16*N)
    

    ;;length of pulse = min time till there is a 100mV difference
    when(N == 64 PulseW = 0e-9 stTime = PulseW + 0.45n)
    when(N == 128 PulseW = 0.05e-9 stTime = PulseW + 0.45n)
    when(N == 256 PulseW = 0.1e-9 stTime = PulseW + 0.5n)
    when(N == 512 PulseW = 0.32e-9 stTime = PulseW + 0.55n)
    when(N == 1024 PulseW = 0.6e-9 stTime = PulseW + 0.8n)

    desVar( "dt" PulseW )
    desVar( "rows" N-2 )
    desVar( "columns" M-8)

    ;;designate capacitance 
    desVar( "cap" capa*N )


    temp( 25 )


    ;;output file
   resultsDir( sprintf(outputFile "./OUT/powerRows%d.txt" N))
    out = outfile(outputFile, "w")

    analysis('tran ?start 0 ?stop stTime ?step 0.01n ?errpreset 'conservative) 

    option( 'reltol 1e-6 'gmin 1e-12 )
    save( "C0.Col0" )
    run()
       
    selectResults('tran) 

   ;;print voltage and current to file
   setup(?numberNotation 'scientific)
   ocnPrint(?output out v("C0.Col0.BL") i("C0.Col0.Dummy.N1.NX:s") getData(":pwr") v("C0.Col0.BLB") i("C0.Col0.Cell1.N4.NX:d"))
)

