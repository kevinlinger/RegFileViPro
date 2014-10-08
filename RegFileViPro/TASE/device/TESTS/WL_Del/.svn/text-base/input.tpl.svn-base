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

;;open new file for each column and block numbers
resultsDir(sprintf(outputFile "./OUT/result.txt"))
out = outfile(outputFile, "w")      

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
    resL = 0.244
    Lwire = M*2.28
    desVar( "Lcap" Lwire*capL)
    desVar("Lres" Lwire*resL)
    
    desVar( "Mul0" 16)
    desVar( "Mul1" 64)
    DW=64
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
     resG = 3.67e-2
     desVar( "Gcap" capG*Gwire)
     desVar( "Gres" resG*Gwire)

    temp( 25 )  


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


 st = cross( v("IN") 0.5 1 'rising)

 gwg = cross( v("C0.WL") 0.5 1 'rising )
 gww = cross( v("C0.WL4") 0.5 1 'rising)
 lwg = cross( v("C0.localWL.WL") 0.5 1 'rising )
 lww = cross( v("C0.localWL.WL4") 0.5 1 'rising)
 maxG = peakToPeak(i("C0.Ip:in"))
 maxL =peakToPeak(i("C0.localWL.Ip:in"))


;;print voltage and current to file
;;order of output: Time/ V on GWL/ I on GWL / V on acc LWL/ I on acc LWL
setup(?numberNotation 'scientific)

;; print results bank/column/GWL/LWL
fprintf( out "%d %d %e %e %e %e %e %e %e\n" B, M, st, gwg, gww, lwg, lww, maxG, maxL )



)
close(out)


















