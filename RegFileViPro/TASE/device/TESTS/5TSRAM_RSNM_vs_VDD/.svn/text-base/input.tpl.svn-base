; Jiajing Wang, 2008-10-06
; Measure Read SNM vs VDD.

; ************************** main code ***************************
simulator( 'spectre )

design(	 "./netlist")
modelFile( 
    '("<include>")
    '("<subN>")
    '("<subP>")
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

desVar(    "wpu1" <wpu1>   )
desVar(    "lpu1" <lpu1>   )
desVar(    "wpu2" <wpu2>   )
desVar(    "lpu2" <lpu2>   )
desVar(    "wpd1" <wpd1>   )
desVar(    "lpd1" <lpd1>   )
desVar(    "wpd2" <wpd2>   )
desVar(    "lpd2" <lpd2>   )
desVar(    "wpg" <wpg>   )
desVar(    "lpg" <lpg>   )

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
      RSNMH = ymax(clip(v("v1mv2h" ?result 'dc) -VDD 0))/sqrt(2)
      RSNML = ymin(clip(v("v1mv2h" ?result 'dc) 0 VDD))/sqrt(2)*(-1)
      RSNM = min(RSNMH,RSNML);
      fprintf(of "%f\t%f\t%f\t%f\n" VDD RSNMH RSNML RSNM)

      VDD = VDD - VDDstep

);end while 
             
drain(of);
close(of);

