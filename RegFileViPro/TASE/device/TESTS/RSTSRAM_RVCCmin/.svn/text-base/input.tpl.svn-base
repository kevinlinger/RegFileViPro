/*
 Ocean script to measure bitcell read VCCmin by sweeping VDD
 
 Author		Jiajing Wang   
 Date		10/13/2008
 Modified by
*/

; ************************** main code ***************************
simulator( 'spectre )
(envSetVal "spectre.opts" "multithread" 'string "on")
(envSetVal "spectre.opts" "nthreads" 'string "3")

;; DATA PATTEN: '0' OR '1' OR Both
;; DATA '0' is hardcoded, since there can be no upset when the cell is storing a 1
DATYPE = 0
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
    
    desVar(       "wp1" <wp1>   )
    desVar(       "lp1" <lp1>   )
    desVar(       "wn1" <wn1>   )
    desVar(       "ln1" <ln1>   )
    desVar(       "wna" <wna>   )
    desVar(       "lna" <lna>   )
    desVar(       "wp2" <wp1>   )
    desVar(       "lp2" <lp1>   )
    desVar(       "wn2" <wn2>   )
    desVar(       "ln2" <ln2>   )
    desVar(       "wrs" <wrs>   )
    desVar(       "lrs" <lrs>   )

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
    
    analysis('dc ?param "pvdd" ?start VDD ?stop 0.05 ?step -0.001)
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
    monteExpr( "VT_PL" "pv(\"ICell.MPL.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_PR" "pv(\"ICell.MPR.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_NL" "pv(\"ICell.MNL.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_NR" "pv(\"ICell.MNR.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_TL" "pv(\"ICell.MTL.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_TR" "pv(\"ICell.MTR.NX.<nModelName>\" \"vtho\" ?result 'model)" )
   
    monteRun()

    delete('monteExpr)
    delete('monteCarlo)

);end foreach(DAT









