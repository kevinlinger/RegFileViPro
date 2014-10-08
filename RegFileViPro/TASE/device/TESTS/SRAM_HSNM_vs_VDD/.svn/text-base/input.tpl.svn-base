; Jiajing Wang, 2008-10-06
; Measure Hold SNM vs VDD.

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
    desVar(   "pvdd" VDD )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )
    desVar(   "pvIn" VDD )


      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ; DC Simulation
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      analysis( 'dc ?param "pvIn" ?start VDD ?stop -1*VDD ?step "-0.001" )
      temp( <temp> ) 
      option( 'reltol 1e-6 'gmin <gmin> )
      run()

      ;; Measure the SNMH SNML SNM
      selectResult('dc)
      SNMH = ymax(clip(v("v1mv2h" ?result 'dc) -VDD 0))/sqrt(2)
      SNML = ymin(clip(v("v1mv2h" ?result 'dc) 0 VDD))/sqrt(2)*(-1)
      SNM = min(SNMH,SNML);
      fprintf(of "%f\t%f\t%f\t%f\n" VDD SNMH SNML SNM)

      VDD = VDD - VDDstep

);end while 
             
drain(of);
close(of);

