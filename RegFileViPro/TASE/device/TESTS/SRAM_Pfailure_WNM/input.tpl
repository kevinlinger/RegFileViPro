; ************************** main code ***************************
simulator( 'spectre )
(envSetVal "spectre.opts" "multithread" 'string "on")
(envSetVal "spectre.opts" "nthreads" 'string "3")

design("./netlist")

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

modelFile(
	'("<include>")
	'("<subN>")
	'("<subP>")
	'("<subPU>")
	'("<subPD>")
	'("<subPG>")
)

desVar(       "wpu" <wpu>   )
desVar(       "lpu" <lpu>   )
desVar(       "wpd" <wpd>   )
desVar(       "lpd" <lpd>   )
desVar(       "wpg" <wpg>   )
desVar(       "lpg" <lpg>   )

desVar(   "ldef" <ldef> )
desVar(   "wdef" <wdef> )
desVar(   "minl" <minl> )
desVar(   "minw" <minw> )
desVar(   "pvin" 0    )


for(i 0 3
    VDD = <pvdd>/2 + i*<VDDstep>

    resultsDir( sprintf(nil "./OUT/WNM%d" i) )

    desVar(   "pvdd" VDD    )

    monteCarlo( ?startIter <mcStartNum> ?numIters <mcrunNum> 
		?analysisVariation variationType
                ?sweptParam "None" ?sweptParamVals "27" ?saveData nil 
                ?append nil ?nomRun nil)
    
    analysis('dc ?param "pvin" ?start "0" ?stop VDD ?step 0.001)
    temp( <temp> ) 
    option( 'reltol 1e-6 'gmin <gmin> )
    delete('save)
    save( 'v "Q" "QB" "WL" "VDD" )
    saveOption( 'save "selected" )

    ;;Measure WL margin
    monteExpr( "WMWL" "value(value(v(\"VDD\" ?result 'dc) <pvdd>) <pvdd>) - cross(v(\"Q\" ?result 'dc)-v(\"QB\" ?result 'dc) 0.001 1 'either)" )
   
    ;; Checking the voltage difference between QB and Q when VWL=VDD.
    ;; This checking is needed since Q and QB might not cross over during WL
    ;;   sweeping but start from the value opposite to the initial node
    ;;   setting and maintain that value all the time.  
    ;; It occurs when the cell's write ability is so strong that Q 
    ;;   and QB flip before rising WL (e.g. using write assist such as drooping cell VDD).
    ;; In this case, write margin should be equal to VDD although the measured
    ;;   data is zero/nil because of no cross-over point.
    monteExpr( "WM_QBmQ" "value(v(\"QB\" ?result 'dc) <pvdd>)-value(v(\"Q\" ?result 'dc) <pvdd>)" )

    ;; Measure the Vth0
    monteExpr( "VT_PL" "pv(\"ICellL.MP.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_PR" "pv(\"ICellR.MP.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_NL" "pv(\"ICellL.MN.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_NR" "pv(\"ICellR.MN.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_TL" "pv(\"ICellL.MT.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_TR" "pv(\"ICellR.MT.NX.<nModelName>\" \"vtho\" ?result 'model)" )
   
    monteRun()

    delete('monteExpr)
    delete('monteCarlo)

);end for
