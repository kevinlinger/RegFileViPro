/*
 Ocean script to measure bitcell write VCCmin by sweeping VDD
 
 Author		Jiajing Wang   
 Date		10/13/2008
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

    design( "./netlist" )

    resultsDir( sprintf(nil "./OUT/DAT%L" DAT) )

    modelFile( 
	'("<include>")
	'("<subN>")
	'("<subP>")
    )

    VDD = <pvdd>
    
    desVar(	  "wpu" <wpu>	)
    desVar(	  "lpu" <lpu>	)
    desVar(	  "wpd" <wpd>	)
    desVar(	  "lpd" <lpd>	)
    desVar(	  "wpg" <wpg>	)
    desVar(	  "lpg" <lpg>	)

    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd" VDD    )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )

    if( DAT==0 then
        nodeset( "ICell.Q" 0 )
        nodeset( "ICell.QB" VDD )
        desVar( "pbl" 1 )
	desVar( "pblb" 0 )
    else
        nodeset( "ICell.Q" VDD )
        nodeset( "ICell.QB" 0 )
        desVar( "pbl" 0 )
	desVar( "pblb" 1 )
    )

    monteCarlo( ?startIter <mcStartNum> ?numIters <mcrunNum> 
		?analysisVariation variationType
                ?sweptParam "None" ?sweptParamVals "27" ?saveData nil 
                ?append nil ?nomRun nil)
    
    ;;;; NOTE:
    ;;;; The VDD sweeping start value is 0.2 instead of 0
    ;;;;   because the cell might also flip below 0.2 due to data retention. 
    ;;;; But the real write VCCmin is actually much higher. 
    ;;;; 'wvccmin_vddscaling.png' shows an example of this scenario.
    ;;;; In this case, if sweeeping from 0, the cell won't flip at higher votlage.
    ;;;; So this simulation can correctly obtain the worst WVCCmin value,
    ;;;;   but cannot get the whole distribution of WVCCmin. 
    ;;;; To obtain the whole distribution of WVCCmin, we can run write margin test with
    ;;;;   the sweep of VDD.
    analysis('dc ?param "pvdd" ?start 0.2 ?stop VDD ?step 0.001)
    temp( <temp> ) 
    option( 'reltol 1e-6 'gmin <gmin> )
    delete('save)
    saveOption( 'save "all" 'currents "all")

    ;;Measure VCCmin    
    if( DAT==0 then
      monteExpr( "VCCmin" "cross(v(\"ICell.Q\" ?result 'dc)-v(\"ICell.QB\" ?result 'dc) 0.001 1 'rising)" )
      ;monteExpr( "VCCmin_fm_Ird" "xmax(deriv(i(\"IBLB:in\" ?result 'dc)))" )
    else 
      monteExpr( "VCCmin" "cross(v(\"ICell.QB\" ?result 'dc)-v(\"ICell.Q\" ?result 'dc) 0.001 1 'rising)" )
      ;monteExpr( "VCCmin_fm_Ird" "xmax(deriv(i(\"IBL:in\" ?result 'dc)))" )
     ) 

    ;; Measure the Vth0
    monteExpr( "VT_PL" "pv(\"ICell.ICellLh.MP.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_PR" "pv(\"ICell.ICellRh.MP.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_NL" "pv(\"ICell.ICellLh.MN.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_NR" "pv(\"ICell.ICellRh.MN.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_TL" "pv(\"ICell.ICellLh.MT.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_TR" "pv(\"ICell.ICellRh.MT.NX.<nModelName>\" \"vtho\" ?result 'model)" )
   
    monteRun()

    delete('monteExpr)
    delete('monteCarlo)

);end foreach(DAT









