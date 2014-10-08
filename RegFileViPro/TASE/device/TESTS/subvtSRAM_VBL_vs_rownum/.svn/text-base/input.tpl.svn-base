/*
 Ocean script to measure BL voltage caused by leakage current
 
 Author		Jiajing Wang   
 Date		06/02/2008
 Modified by
*/


; ************************** main code ***************************
simulator( 'spectre )

design( "./netlist" )

VDD = <pvdd>

desVar(	  "wpu" <wpu>	)
desVar(	  "lpu" <lpu>	)
desVar(	  "wpd" <wpd>	)
desVar(	  "lpd" <lpd>	)
desVar(	  "wpg" <wpg>	)
desVar(	  "lpg" <lpg>	)
desVar(   "wrdpg" <wrdpg> )
desVar(   "lrdpg" <lrdpg> )
desVar(   "wrdn1" <wrdn1> )
desVar(   "lrdn1" <lrdn1> )
desVar(   "wrdp1" <wrdp1> )
desVar(   "lrdp1" <lrdp1> )
desVar(   "wrdn2" <wrdn2> )
desVar(   "lrdn2" <lrdn2> )

desVar(   "ldef" <ldef> )
desVar(   "wdef" <wdef> )
desVar(   "minl" <minl> )
desVar(   "minw" <minw> )

desVar(   "pvdd" VDD    )
desVar(   "pvbp" VDD    )
desVar(   "pvddrd" <pvddrd> )
desVar(   "pvssrd" <pvssrd> )

desVar(   "rowsm1" <rowsM1> )

desVar(   "ptdelay" <tdelay> )
desVar(   "ptrise" <trise>   )
desVar(   "ptfall" <tfall>   )
desVar(   "ptwidth" <twidth> )


;;; For single-ended read, both cases of reading '0' and '1' should be run
DATList = '(0 1)  ;Both '0' and '1' case will be run


sh( "mkdir DAT" )

ROWNUM = 16


delay_of = outfile( "./DAT/BLdelay.dat" "w")
dBLmax_of = outfile( "./DAT/dVBLmax.dat" "w")

;;;;;;;;;;;;;;;; Main Loop for altering the number of rows ;;;;;;;;;;;;;;;

while( ROWNUM<1025

   desVar(   "rowsm1" ROWNUM-1 )

   

   ;;;;;;;;;;;;;; Loop for altering data pattern ;;;;;;;;;;
   
   foreach( DAT DATList

       resultsDir( sprintf(nil "./OUT/R%L/DAT%L" ROWNUM DAT) )

       of = outfile( sprintf(nil "./DAT/R%L_D%L.dat" ROWNUM DAT) "w")     
       
       ;; Initializing nodes
       for( c 3 7
           if( DAT==0 then
	       ic( sprintf(nil "ICell%L_act.Q" c) 0 )
	       ic( sprintf(nil "ICell%L_act.QB" c) VDD )
	       ic( sprintf(nil "ICell%L_idl.Q" c) VDD )
	       ic( sprintf(nil "ICell%L_idl.QB" c) 0 )
	   else 
	       ic( sprintf(nil "ICell%L_act.QB" c) 0 )
	       ic( sprintf(nil "ICell%L_act.Q"  c) VDD )
	       ic( sprintf(nil "ICell%L_idl.QB" c) VDD )
	       ic( sprintf(nil "ICell%L_idl.Q"  c) 0 ) 
	   )
       )


       ;;;;;;;;;;;;;; Loop for altering access transistor Vt ;;;;;;;;;;
       ;;;;;;;;;;;;;; Using the worst case: 6 sigma Vt variation ;;;;;;;;;
       for( i 6 6

           modelFile( 
	       '("<include>")
	       '("<subN>")
	       '("<subP>")
	   )	   

	   ;; set active cell access FET VT mismatch
	   desVar( "pdvtsig_act" i )
	   desVar( "pdvtsig_idl" 0 )

	   analysis('tran ?start 0 ?stop <ttran> ?errpreset 'conservative)
	   temp( <temp> ) 
	   option( 'reltol 1e-6 'gmin <gmin> )
	   delete('save)
	   saveOption( 'save "all"  
			  'currents ""
			  'pwr	 ""
			  'nestlvl	 ""
			  ?outputParamInfo nil 
			  ?elementInfo nil
			  ?primitivesInfo nil
			  ?subcktsInfo nil 
			  ?modelParamInfo t
			  'subcktprobelvl 0 )
	   run()

	   ;;Measure the BL voltage when everything is settled 
	   selectResults('tran)
	   Vbl0 = value(v("BL0")   <twidth>-10*<tfall> )
	   Vblb0 = value(v("BLB0") <twidth>-10*<tfall> )
	   Vbl1 = value(v("BL1")   <twidth>-10*<tfall> )
	   Vblb1 = value(v("BLB1") <twidth>-10*<tfall> )  
	   Vbl2 = value(v("BL2")   <twidth>-10*<tfall> )
	   Vblb2 = value(v("BLB2") <twidth>-10*<tfall> ) 
	   Vbl3 = value(v("RBL3")  <twidth>-10*<tfall> )  
	   Vbl4 = value(v("RBL4")  <twidth>-10*<tfall> )  
	   Vbl5 = value(v("RBL5")  <twidth>-10*<tfall> )  
	   Vbl6 = value(v("RBL6")  <twidth>-10*<tfall> )  
	   Vbl7 = value(v("RBL7")  <twidth>-10*<tfall> )  	   
	   VTact = pv("ICell3_act.MRD0.NX.<nModelName>" "vtho" ?result 'model)
	   VTidl = pv("ICell3_idl.MRD0.NX.<nModelName>" "vtho" ?result 'model)
	   fprintf(of "%f\t%f\t%f\t%f\t%f\t%f\t" Vbl0 Vbl1 Vbl2 Vblb0 Vblb1 Vblb2)   
	   fprintf(of "%f\t%f\t%f\t%f\t%f\t%f\t%f\n" Vbl3 Vbl4 Vbl5 Vbl6 Vbl7 VTact VTidl)

           twls = <tdelay>+<trise> 
	   twle = <tdelay>+<trise>+<twidth>
	   Vbl_0  = clip(v("BL0")  twls twle)  
	   Vblb_0 = clip(v("BLB0") twls twle) 
	   Vbl_1  = clip(v("BL1")  twls twle)  
	   Vblb_1 = clip(v("BLB1") twls twle) 
	   Vbl_2  = clip(v("BL2")  twls twle) 
	   Vblb_2 = clip(v("BLB2") twls twle) 
	   
	   if( DAT==0 then
	 	 Vbl_3 = clip(v("RBL3") twls twle) 
		 Vbl_4 = clip(v("RBL4") twls twle)   
		 Vbl_5 = clip(v("RBL5") twls twle)  
		 Vbl_6 = clip(v("RBL6") twls twle)  
		 Vbl_7 = clip(v("RBL7") twls twle)  
	   else
		 Vblb_3 = clip(v("RBL3") twls twle) 
		 Vblb_4 = clip(v("RBL4") twls twle)   
		 Vblb_5 = clip(v("RBL5") twls twle)  
		 Vblb_6 = clip(v("RBL6") twls twle)  
		 Vblb_7 = clip(v("RBL7") twls twle) 
           )


       );end for(i

       ;;;;;;;;;;;;;; end of loop for altering access transistor vth ;;;;;;;;;;

       drain( of )
       close( of )

   );end foreach(DAT

   ;;;; Obtain the time required for getting the difference voltage btw BL and BLB ;;;;
   dBL_0 = Vblb_0 - Vbl_0
   dBL_1 = Vblb_1 - Vbl_1
   dBL_2 = Vblb_2 - Vbl_2
   dBL_3 = Vblb_3 - Vbl_3
   dBL_4 = Vblb_4 - Vbl_4
   dBL_5 = Vblb_5 - Vbl_5
   dBL_6 = Vblb_6 - Vbl_6
   dBL_7 = Vblb_7 - Vbl_7

   mdBL_0 = ymax(dBL_0)
   mdBL_1 = ymax(dBL_1)
   mdBL_2 = ymax(dBL_2)
   mdBL_3 = ymax(dBL_3)
   mdBL_4 = ymax(dBL_4)
   mdBL_5 = ymax(dBL_5)
   mdBL_6 = ymax(dBL_6)
   mdBL_7 = ymax(dBL_7)
   Tbl_0 = xmax(dBL_0 1)
   Tbl_1 = xmax(dBL_1 1)
   Tbl_2 = xmax(dBL_2 1)
   Tbl_3 = xmax(dBL_3 1)
   Tbl_4 = xmax(dBL_4 1)
   Tbl_5 = xmax(dBL_5 1)
   Tbl_6 = xmax(dBL_6 1)
   Tbl_7 = xmax(dBL_7 1)
   
   
   fprintf(delay_of "%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n" 
		    ROWNUM Tbl_0 Tbl_1 Tbl_2 Tbl_3 Tbl_4 Tbl_5 Tbl_6 Tbl_7)
   fprintf(dBLmax_of "%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n" 
		    ROWNUM mdBL_0 mdBL_1 mdBL_2 mdBL_3 mdBL_4 mdBL_5 mdBL_6 mdBL_7)		    
   ;;;;;;;;;;;;;; end of loop for altering row num ;;;;;;;;;;

   ROWNUM = ROWNUM*2


);end while(ROWNUM

;;;;;;;;;;;;;;;; end of main Loop for altering the number of rows ;;;;;;;;;;;;;;;

drain(delay_of)
close(delay_of)
drain(dBLmax_of)
close(dBLmax_of)


