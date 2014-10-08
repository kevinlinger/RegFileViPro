/*
 Ocean script to measure bitcell write margin by sweeping BL voltage
 
 Author		Jiajing Wang   
 Date		02/11/2008
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
    cpfile = sprintf(nil "cp -f ./DAT%L/netlist ." DAT)
    sh( cpfile )
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
    
    desVar(	  "wpu" <wpu>	)
    desVar(	  "lpu" <lpu>	)
    desVar(	  "wpd" <wpd>	)
    desVar(	  "lpd" <lpd>	)
    desVar(	  "wpg" <wpg>	)
    desVar(	  "lpg" <lpg>	)

    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd"   <pvdd> )
    desVar(   "pvdda"  <pvdda> )
    desVar(   "pvddwl" <pvddwl> )
    desVar(   "pvin" 0      )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )
    
;;;;;;;;;;;; MC ;;;;;;;;;;;;;;;;;;;  
    monteCarlo( ?startIter <mcStartNum> ?numIters <mcrunNum> 
                ?analysisVariation variationType
                ?sweptParam "None" ?sweptParamVals "27" ?saveData nil
                ?append nil ?nomRun nil)

    analysis('dc ?param "pvin" ?start <pvdd> ?stop "0" ?step "-0.001")
    temp(<temp>)
    option( 'reltol 1e-6 'gmin <gmin> )

    ;; Measurement 
    ;;Method-2: Write margin is the BL voltage value when Q and QB flip 
    monteExpr( "WM_fm_VQ" "cross(v(\"QB\" ?result 'dc)-v(\"Q\" ?result 'dc) 0 1 'either)" )

    ;;Method-1: Write margin is the BLB voltage value when the read current (on
    ;;          BL terminal) drops with the highest speed (i.e. the largest 
    ;;          derivative)
    monteExpr( "WM_fm_Ird" "xmax(deriv(i(\"IRD:in\" ?result 'dc)))+0.001" )

    ;; Checking the voltage difference between QB and Q when VBL=0.
    ;; This checking is needed since Q and QB might not cross over during BL
    ;;   sweeping but start from the value opposite to the initial node
    ;;   setting and maintain that value all the time.  
    ;; It occurs when the cell's write ability is so strong that Q 
    ;;   and QB flip at the instant of rising WL before sweeping BL down.
    ;; In this case, write margin should be equal to VDD although the measured
    ;;   data "WM_fm_Ird"/"WM_fm_VQ" is zero/nil because of no cross-over point.
    monteExpr( "WM_QBmQ" "value(v(\"QB\" ?result 'dc) 0)-value(v(\"Q\" ?result 'dc) 0)" )

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

);end foreach(DAT










