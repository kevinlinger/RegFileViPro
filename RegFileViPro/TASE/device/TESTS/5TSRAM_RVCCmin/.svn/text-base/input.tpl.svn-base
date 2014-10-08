/*
 Ocean script to measure bitcell read VCCmin by sweeping VDD
 
 Author		Jiajing Wang   
 Date		10/13/2008
 Modified by	Satya Nalam
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

    design( "./netlist" )

    resultsDir( sprintf(nil "./OUT/DAT%L" DAT) )

    modelFile( 
	'("<include>")
	'("<subN>")
	'("<subP>")
    )

    VDD = <pvdd>
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
    desVar(   "pvdd" VDD    )
    desVar(   "pvbp" VDD    )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )
    desVar(   "pvin" 0    )

    if( DAT==0 then
        nodeset( "ICell.Q" 0 )
        nodeset( "ICell.QB" VDD )
    else
        nodeset( "ICell.Q" VDD )
        nodeset( "ICell.QB" 0 )
    )

    monteCarlo( ?startIter <mcStartNum> ?numIters <mcrunNum> 
		?analysisVariation variationType
                ?sweptParam "None" ?sweptParamVals "27" ?saveData nil 
                ?append nil ?nomRun t)
    
    analysis('dc ?param "pvdd" ?start VDD ?stop 0 ?step -0.001)
    temp( <temp> ) 
    option( 'reltol 1e-6 'gmin <gmin> )
    delete('save)
    saveOption( 'save "all" 'currents "all")

    ;;Measure VCCmin    
    if( DAT==0 then
      monteExpr( "VCCmin" "cross(v(\"ICell.QB\" ?result 'dc)-v(\"ICell.Q\" ?result 'dc) 0.001 1 'falling)" )
      ;monteExpr( "VCCmin_fm_Ird" "xmin(deriv(i(\"IBLB:in\" ?result 'dc)))+0.001" )
    else 
      monteExpr( "VCCmin" "cross(v(\"ICell.Q\" ?result 'dc)-v(\"ICell.QB\" ?result 'dc) 0.001 1 'falling)" )
      ;monteExpr( "VCCmin_fm_Ird" "xmin(deriv(i(\"IBL:in\" ?result 'dc)))+0.001" )
     ) 

    ;; Measure the Vth0
    monteExpr( "VT_PL" "pv(\"ICell.ICellLh.MP.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_PR" "pv(\"ICell.ICellRi.MP.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_NL" "pv(\"ICell.ICellLh.MN.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_NR" "pv(\"ICell.ICellRi.MN.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_TL" "pv(\"ICell.ICellLh.MT.NX.<nModelName>\" \"vtho\" ?result 'model)" )
   
    monteRun()

    delete('monteExpr)
    delete('monteCarlo)

);end foreach(DAT









