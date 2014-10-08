; Randy Mann, 2009-2-23
; Characterize 6T cell read time

; ************************** main code ***************************
simulator( 'spectre )
design(	 "./netlist")
modelFile( 
    '("<include>")
    '("<subN>")
    '("<subP>")
    '("<subPG>")
    '("<subPD>")
    '("<subPU>")
   
)




    VDD = <pvdd>
;;define trigger voltage for sense amp
    TRIG= VDD-.1
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
    desVar(   "blcap" <blcap>   ) 
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

  analysis( 'tran ?start 0 ?stop 20n ?step 0.01n ?strobeperiod 0.001n ?errpreset 'moderate )


;;these next two lines are critical
option( 'gmin 1e-15)
save('all)

 run()




 selectResults('tran)

tread= cross((v("C")-v("E")) .1 1 'rising)- cross(v("VWL") .5 1 'rising)


delta=v("C")- v("E")

;; include the next 2 lines to plot the wave forms
;;plot( v("A") v("B")  v("VWL") v("C") v("E") ?expr list("nA" "nB" "WL" "BL" "BLB" ) )

;;plot( v("C")- v("E")  ?expr list("deltaBL"))


tr= tread*1e9  ; time to read in ns



of = outfile( "tread_out.txt" "w")


fprintf( of "%g\t%f\n", node, tr  )

close(of)