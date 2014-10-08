; Jiajing Wang, 2008-12-16
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
VDDstep = <pvdd>/15

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
   
    desVar(   "pvbl" VDD )
    desVar(   "pvblb" 0  )
    nodeset( "ICell.Q" 0 )
    nodeset( "ICell.QB" VDD )

      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ; DC Simulation
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      analysis( 'dc ?param "pvin" ?start 0 ?stop VDD*1.5 ?step "0.001" )
      temp( <temp> ) 
      option( 'reltol 1e-6 'gmin <gmin> )
      run()

      ;; Measure the SNMH SNML SNM
      selectResult('dc)
      WMWL = cross(v("ICell.Q" ?result 'dc)-v("ICell.QB" ?result 'dc) 0.001 1 'either)
      QBmQ = value(v("ICell.QB" ?result 'dc) VDD)-value(v("ICell.Q" ?result 'dc) VDD)
      if( !WMWL then
         if(QBmQ<0 then
          WMWL=VDD
         else
          WMWL=0.0
         )
      else 
         WMWL=VDD-WMWL
      ) 
      fprintf(of "%f\t%f\t%f\n" VDD WMWL QBmQ)

      VDD = VDD - VDDstep

);end while 
             
drain(of);
close(of);

