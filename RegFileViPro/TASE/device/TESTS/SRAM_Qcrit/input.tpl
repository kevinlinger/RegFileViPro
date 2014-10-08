; Randy Mann, 2008-10-6
; Characterize 6T cell Qcrit.

; ************************** main code ***************************
simulator( 'spectre )
design(	 "./netlist")
modelFile( 
    '("<include>")
    '("<subN>")
    '("<subP>")
   
)




VDD = <pvdd>
;;VDD = 1


    desVar(	  "wpu" <wpu>	)
    desVar(	  "lpu" <lpu>	)
    desVar(	  "wpd" <wpd>	)
    desVar(	  "lpd" <lpd>	)
    desVar(	  "wpg" <wpg>	)
    desVar(	  "lpg" <lpg>	)
    desVar(   "nncap" <nncap>   )   
 
    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd" <pvdd> )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )



;; this program assume a particle strike on the n+ diff of the high node
;; a current pulseshape input is defined in the netlist or .scs file

;; ncap=evalstring( desVar("nncap"))  
 Lp=evalstring( desVar("ldef")) 
 node=Lp*1e9   

 desVar( "tend" 0.5n)  ; time at end of simulation  
 vali=50u              ; this is the default initial Ic value 
 ;;vali=ldef*1000      ; this is the default initial Ic value
 Inc = 5u              ; this is the default increment for finding Qcrit
 valt=0                ; initialize the value
 

/* _________________________________*/
/* this begins the while loop phase */
/* _________________________________*/

test=nil  ; initialize value for the while loop

while(test==nil     
desVar("Ic" vali)

  ;; RUN ANALYSIS
  analysis( 'tran ?start 0 ?stop "tend" ?step 0.01n ?strobeperiod 0.001n ?errpreset 'conservative )


;;these next two lines are critical to getting Ic to plot
option( 'gmin 1e-15)
save('all)

 run()


 ;;   save(i("I1:sink" ))
 ;;   save(v("A"))
 ;;   save(v("B"))
 ;;   save('all)

 selectResults('tran)
tflip= cross( (v("A")-v("B")) -.001 1 'falling) ; should return the t value

if( tflip==nil  valt=0 valt=tflip)

delta=v("A")- v("B")


Qc=value(integ(i("I1:sink" ?result "tran-tran"),50p ,500p) 500p )
Qcx=abs(value(integ(i("I1:sink" ?result "tran-tran"),50p ,valt) 500p))
if( Qcx>0 Qcrx=Qcx Qcrx=0)

;;plot( v("A") v("B") i("I1:sink")   ?expr list("nA" "nB" "particle_pulse" ) )
;;plot(iinteg(i("I1:sink" ?result "tran-tran")))

;;plot( v("A")- v("B")  ?expr list("deltaAB"))

vcap=evalstring( desVar("nncap"))
capadd=vcap*1e15 	 
val1=evalstring( desVar("Ic"))
valIc=val1*1e6    ; get Ic in uA
val4= value(v("A") 50p)
val5=value(v("A") .5n)
valqc=Qc*1e15  ; get Qcritin fC
Qcrit= Qcrx*1e15 ; get true Qcrit (integ for time to flip) in fC


vali=val1 + Inc
test=tflip
tf= valt*1e12  ; time to flip in ps


;; valid outputs -  model, valIc, val4, val5, valqc,Qcrit, tf 




  ) ; close while loop which should continue until test = non-nill

of = outfile( "finalout.txt" "w")


fprintf( of "%g\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n", node, valIc, val4, val5, valqc,Qcrit, tf, capadd  )

close(of)