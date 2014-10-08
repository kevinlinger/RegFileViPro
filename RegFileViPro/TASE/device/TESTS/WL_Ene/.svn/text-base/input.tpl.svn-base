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

   ;; N = number of rows
   N = 256
   ;;M = number of columns
   foreach( M '(16 32 64 128 256)
   ;;M=256
   ;;B = Number of banks
   B = (2**18)/(M*256)

    desVar( "cols" M-2)
    desVar( "banks" B-1)
    ;;set Capacitance on LWL length = 2.28u*no of columns
    capL = 0.202E-15
    Lwire = M*2.28
    desVar( "Lcap" Lwire*capL)
    
    
    desVar( "Mul0" M/8)
    desVar( "Mul1" M/2)
    Dw=64
    when(B==4 Dr= DW*1.7 )
    when(B==8 Dr= DW*1.7 )
    when(B==16 Dr=DW*1.7 )
    when(B==32 Dr=DW*1.7 )
    when(B==64 Dr=DW*1.7 )
    
    desVar( "MulG0" Dr/4)
    desVar( "MulG1" Dr)

    ;;set Capacitance and resistance on GWL

     capG = 0.234E-15
     Gwire = M*B*2.28
     resG = 3.67e3
     desVar( "Gcap" capG*Gwire)
     desVar( "Gres" resG*Gwire)

    temp( 25 )  

resultsDir("./results")

;;open new file for each column and block numbers
resultsDir(sprintf(outputFile "./OUT/GWL/Gpower%d.txt" B))
out = outfile(outputFile, "w")    
resultsDir(sprintf(s "./OUT/LWL/Lpower%d.txt" M))
of = outfile(s, "w")

;; set simulation length width of WL pulse from the Array simulation
    when(M == 256 PulseW = 0.02e-9 stTime = PulseW + 0.4n+0.2n)
    when(M == 128 PulseW = 0.05e-9 stTime = PulseW + 0.35n+0.2n)
    when(M == 64 PulseW = 0.1e-9 stTime = PulseW + 0.35n+0.2n)
    when(M == 32 PulseW = 0.32e-9 stTime = PulseW + 0.34n+0.2n)
    when(M == 16 PulseW = 0.6e-9 stTime = PulseW + 0.32n+0.2n)
   desVar("ww" stTime-0.4n)


    analysis('tran ?start 0 ?stop stTime ?step 1p ?strobeperiod 1p ?errpreset 'conservative)     
    option( 'reltol 1e-6 'gmin 1e-12 )
    save( 'all )
    run()
  selectResults('tran)
 ;;plot WL pulses
  addSubwindow()
  plot( v("C0.WL") v("C0.localWL.WL"))



;;print voltage and current to file
;;order of output: Time/ V on GWL/ I on GWL / V on acc LWL/ I on acc LWL
setup(?numberNotation 'scientific)
;; print results for GWL
ocnPrint(?output out v("C0.WL") i("C0.Ip:in") getData("C0.Dr1.N2:pwr") getData("C0.Dr1.P2:pwr") getData("C0.AND:pwr") getData("C0.ANDd:pwr"))

;;print results for LWL
ocnPrint(?output of  v("C0.localWL.WL")  i("C0.localWL.Ip:in") getData("C0.localWL.Dr1.P4:pwr") getData("C0.localWL.Dr1.N4:pwr") )

close(out)

)
















