/*
 Ocean script to measure bitcell write margin by VTC curves
 
 Author		Jiajing Wang   
 Date		02/11/2008
 Modified by
*/

; ************************** main code ***************************
simulator( 'spectre )

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


;; Main Loop
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

    VDD_sweep = <pvdd>
    
    desVar(	  "wpu" <wpu>	)
    desVar(	  "lpu" <lpu>	)
    desVar(	  "wpd" <wpd>	)
    desVar(	  "lpd" <lpd>	)
    desVar(	  "wpg" <wpg>	)
    desVar(	  "lpg" <lpg>	)

    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd"   <pvdd>    )
    desVar(   "pvdda"  <pvdda> )
    desVar(   "pvddwl" <pvddwl> )
    desVar(   "pvin" 0      )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )

;;;;;;;;;;;; MC ;;;;;;;;;;;;;;;;;;;  
    monteCarlo( ?startIter <mcStartNum> ?numIters <mcrunNum> 
                ?analysisVariation variationType
                ?sweptParam "None" ?sweptParamVals "27" ?saveData nil
                ?append nil ?nomRun t)

    analysis('dc ?param "pvin" ?start (-1)*VDD_sweep*sqrt(2)/2 ?stop VDD_sweep*sqrt(2)/2 ?step 0.001)
    temp( <temp> )
    option( 'reltol 1e-6 'gmin <gmin> )

    ;;;;;;; Measurement 
    ;; The trip voltage of the read VTC curve
    monteExpr( "VM" "value(v(\"v1\" ?result 'dc) 0)/sqrt(2)" )
    ;; The voltage of node '1' when input is 0
    monteExpr( "VOH_inv1" "cross(v(\"v2\" ?result 'dc)-v(\"U\" ?result 'dc) 0 1 'falling)*sqrt(2)" )
    ;; The smallest square (note: v2 should be clipped to be smaller than VOH_inv1)
    monteExpr( "WM" "ymin(clip(v(\"v1mv2\" ?result 'dc) 0 cross(v(\"v2\" ?result 'dc)-v(\"U\" ?result 'dc) 0 1 'falling)))/sqrt(2)" )

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










