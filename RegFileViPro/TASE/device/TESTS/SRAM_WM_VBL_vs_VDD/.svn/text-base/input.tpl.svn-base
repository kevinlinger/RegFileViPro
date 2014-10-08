; Jiajing Wang, 2008-10-06
; Measure Write Margin vs VDD.

; ************************** main code ***************************
simulator( 'spectre )

design(	 "./netlist")
modelFile( 
    '("<include>")
    '("<subN>")
    '("<subP>")
    	'("<subPU>")
	'("<subPD>")
	'("<subPG>")
)


;; MONTE CARLO ITERATION NUMBER
nIt = <mcrunNum>

;; MONTE CARLO TYPE
mcType = "<mcType>"
if( mcType=="all" then
     variationType='processAndMismatch
else
  if( mcType=="mismatch" then
     variationType='mismatch
  else 
     variationType='process
  )
)

VDD = <pvdd>
VDDstep = 0.1

of = outfile("./out.dat","w")

resultsDir( "./OUT" )

while( (VDD>(VDDstep/2))

    desVar(	  "wpu" <wpu>	)
    desVar(	  "lpu" <lpu>	)
    desVar(	  "wpd" <wpd>	)
    desVar(	  "lpd" <lpd>	)
    desVar(	  "wpg" <wpg>	)
    desVar(	  "lpg" <lpg>	)

    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd" VDD    )
    desVar(   "pvbp" VDD    )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )
    desVar(   "pvin" VDD    )


      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ; DC Simulation
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      analysis( 'dc ?param "pvin" ?start VDD ?stop "0" ?step "-0.001" )
      temp( <temp> ) 
      option( 'reltol 1e-6 'gmin <gmin> )
      run()

      ;; Measure the SNMH SNML SNM
      selectResult('dc)
      WM_fm_Ird = xmax(deriv(i("IRD:in" ?result 'dc)))+0.001
      WM_QBmQ = value(v("QB" ?result 'dc) VDD)-value(v("Q" ?result 'dc) VDD)
      fprintf(of "%f\t%f\t%f\n" VDD WM_fm_Ird WM_QBmQ)

      VDD = VDD - VDDstep

);end while 
             
drain(of);
close(of);

