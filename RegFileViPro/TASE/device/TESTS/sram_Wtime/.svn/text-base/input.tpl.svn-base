; Randy Mann, 2009-2-23
; Characterize 6T cell write time

; ************************** main code ***************************
simulator( 'spectre )
design(	 "./netlist")
modelFile( 
    '("<include>")
    '("<subN>")
    '("<subP>")
   
)




    VDD = <pvdd>
 
    VSS= <pvss>
    VBL= <bitline>
    WLV= <wlv>
    LBL= <lbl>
   TEMP=<temp>

    desVar(	  "wpu" <wpu>	)
    desVar(	  "lpu" <lpu>	)
    desVar(	  "wpd" <wpd>	)
    desVar(	  "lpd" <lpd>	)
    desVar(	  "wpg" <wpg>	)
    desVar(	  "lpg" <lpg>	)
    desVar(   "nncap" <nncap>   )  
    desVar(   "res1" <res1>     ) 
 
    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd" <pvdd> )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )

    desVar(   "pvbp" <pvbp> )
    desVar(   "wlv"  <wlv>  )
    desVar(   "pvbn" <pvbn> )
    desVar(   "pvdda" <pvdda>    )
    desVar(   "pvss" VSS    )
    desVar(   "lbl" <lbl>   )
    desVar(   "bitline" <bitline> )
   


 Lp=evalstring( desVar("ldef")) 
 node=Lp*1e9   

temp( <temp> )

  analysis( 'tran ?start 0 ?stop 2n ?step 0.001n ?strobeperiod 0.0001n ?errpreset 'conservative )


;;these next two lines are critical
option( 'gmin 1e-15)
save('all)

 run()




 selectResults('tran)
;; original line below for jssc below
;;tflip= cross( (v("A")-v("B")) -.001 1 'falling) ; should return the t value
;;new line created 7/1/09
tflip= cross( (v("A")-v("B")) -.001 1 'falling)-cross(v("VWL") .5 1 'rising)

if( tflip==nil  valt=1 valt=tflip)

delta=v("A")- v("B")


;;plot( v("A") v("B")  v("VWL")  ?expr list("nA" "nB" "WL" ) )



;;plot( v("A")- v("B")  ?expr list("deltaAB"))


tf= valt*1e12  ; time to flip in ps



of = outfile( "twrite_out.txt" "w")


fprintf( of "%g\t%f\n", node, tf  )

close(of)