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


VDD = <pvdd>

of = outfile("./out.dat","w")

resultsDir( "./OUT" )

wn2_ini = <wn2>
lp1_ini = <lp1>
N2step = <N2step>
P1step = <P1step>

desVar(       "wp1" <wp1>   )
desVar(       "wn1" <wn1>   )
desVar(       "ln1" <ln1>   )
desVar(	      "wna" <wna>   )
desVar(       "lna" <lna>   )
desVar(       "wp2" <wp1>   )
desVar(       "lp2" <lp1>   )
desVar(       "ln2" <ln2>   )
desVar(       "wrs" <wrs>   )
desVar(       "lrs" <lrs>   )

desVar(   "ldef" <ldef> )
desVar(   "wdef" <wdef> )
desVar(   "pvdd" VDD )
desVar(   "minl" <minl> )
desVar(   "minw" <minw> )
desVar(   "pvIn" VDD )

for( i 0 4
  for( j 0 2
    fprintf(of "%d\t%d\n" i j)
    desVar(       "lp1" lp1_ini-P1step*j   )
    desVar(       "wn2" wn2_ini+N2step*i   )
    ;desVar(       "wrs" wn2_ini+N2step*i   )

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
      fprintf(of "%f\t%f\t%f\n" RSNMH RSNML RSNM)

      drain(of);
  )
)
             
close(of);
