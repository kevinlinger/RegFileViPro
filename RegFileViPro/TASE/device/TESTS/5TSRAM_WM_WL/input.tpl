/*
 Ocean script to measure bitcell write margin by sweeping WL voltage
  on both access transistors
 
 Author		Jiajing Wang   
 Date		05/03/2008
 Modified by
*/

; ************************** main code ***************************
simulator( 'spectre )
(envSetVal "spectre.opts" "multithread" 'string "on")
(envSetVal "spectre.opts" "nthreads" 'string "3")

;; DATA PATTEN: '0' OR '1' OR Both
DATYPE = <pdat> 
if( DATYPE==2 then
    DATList = '(0 1)  ;Both '0' and '1' case will be run
else 
    if( DATYPE==1 then
      DATList = '(1)
    else
      DATList = '(0)
    )
)


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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

foreach( DAT DATList

    ;; COPY THE CORRISPONDING NETLIST FOR THE DESIRED DATA PATTERN
    ;design( sprintf(nil "./DAT%L/netlist" DAT) )
    cpnetlist = sprintf(nil "cp -f ./DAT%L/netlist ." DAT)
    sh( cpnetlist )
    design( "./netlist" )

    resultsDir( sprintf(nil "./OUT/DAT%L" DAT) )

    modelFile( 
	'("<include>")
	'("<subN>")
	'("<subP>")
	'("<subPU>")
	'("<subPD>")
	'("<subPG>")
    )

    VDD = <pvdd>
    VDDWL = <pvddwl>
    
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
    desVar(   "pvdd" <pvdd>    )
    desVar(   "pvdda" <pvdda>    )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )
    desVar(   "pvin" 0    )

    monteCarlo( ?startIter <mcStartNum> ?numIters <mcrunNum> 
		?analysisVariation variationType
                ?sweptParam "None" ?sweptParamVals "27" ?saveData nil 
                ?append nil ?nomRun nil)
    
    analysis('dc ?param "pvin" ?start "0" ?stop VDDWL ?step 0.001)
    temp( <temp> ) 
    option( 'reltol 1e-6 'gmin <gmin> )
    delete('save)
    save( 'v "ICell.Q" "ICell.QB" "WL" "VDD" "BL")
    saveOption( 'save "selected" )

    ;;Measure WL margin
    monteExpr( "WMWL" "<pvddwl> - cross(v(\"ICell.Q\" ?result 'dc)-v(\"ICell.QB\" ?result 'dc) 0.001 1 'either)" )
   
    ;; Checking the voltage difference between QB and Q when VWL=VDDWL.
    ;; This checking is needed since Q and QB might not cross over during WL
    ;;   sweeping but start from the value opposite to the initial node
    ;;   setting and maintain that value all the time.  
    ;; It occurs when the cell's write ability is so strong that Q 
    ;;   and QB flip before rising WL (e.g. using write assist such as drooping cell VDD).
    ;; In this case, write margin should be equal to VDD although the measured
    ;;   data is zero/nil because of no cross-over point.
    monteExpr( "WM_QBmQ" "value(v(\"ICell.QB\" ?result 'dc) <pvddwl>)-value(v(\"ICell.Q\" ?result 'dc) <pvddwl>)" )

    ;; Measure the Vth0
    ;monteExpr( "VT_PL" "pv(\"ICell.MPR.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    ;monteExpr( "VT_PR" "pv(\"ICell.MPL.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    ;monteExpr( "VT_NL" "pv(\"ICell.MNR.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    ;monteExpr( "VT_NR" "pv(\"ICell.MNL.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    ;monteExpr( "VT_TL" "pv(\"ICell.MTL.NX.<nModelName>\" \"vtho\" ?result 'model)" )
   
    monteRun()

    delete('monteExpr)
    delete('monteCarlo)

);end foreach(DAT
