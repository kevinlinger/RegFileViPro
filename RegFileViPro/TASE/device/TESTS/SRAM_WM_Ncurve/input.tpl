/*
 Ocean script to measure bitcell write margin by N-curve
 
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

VDD = <pvdd>

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

    desVar(	  "wpu" <wpu>	)
    desVar(	  "lpu" <lpu>	)
    desVar(	  "wpd" <wpd>	)
    desVar(	  "lpd" <lpd>	)
    desVar(	  "wpg" <wpg>	)
    desVar(	  "lpg" <lpg>	)

    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd" VDD )
    desVar(   "pvbp" VDD )
    desVar(   "pvin" 0      )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )


;;;;;;;;;;;; MC ;;;;;;;;;;;;;;;;;;;  
    monteCarlo( ?startIter <mcStartNum> ?numIters <mcrunNum> 
                ?analysisVariation variationType
                ?sweptParam "None" ?sweptParamVals "27" ?saveData nil
                ?append nil ?nomRun t)

    analysis('dc ?param "pvin" ?start "0" ?stop VDD ?step 0.001)
    temp( <temp> )
    option( 'reltol 1e-6 'gmin <gmin> )

  ;; Measurement 
    monteExpr( "VINA" "cross(i(\"VVIN:p\" ?result 'dc) 0 1 'either)" )
    monteExpr( "VINB" "cross(i(\"VVIN:p\" ?result 'dc) 0 2 'either)" )
    monteExpr( "VINC" "cross(i(\"VVIN:p\" ?result 'dc) 0 3 'either)" )

    monteExpr( "SVNM" "cross(i(\"VVIN:p\" ?result 'dc) 0 2 'either) - cross(i(\"VVIN:p\" ?result 'dc) 0 1 'either)")
    monteExpr( "SINM" "ymax(clip(i(\"VVIN:p\" ?result 'dc)*(-1) cross(i(\"VVIN:p\" ?result 'dc) 0 1 'either) cross(i(\"VVIN:p\" ?result 'dc) 0 2 'either)))")

    monteExpr( "WTV" "cross(i(\"VVIN:p\" ?result 'dc) 0 3 'either) - cross(i(\"VVIN:p\" ?result 'dc) 0 2 'either)")
    monteExpr( "WTI" "abs(ymin(clip(i(\"VVIN:p\" ?result 'dc)*(-1) cross(i(\"VVIN:p\" ?result 'dc) 0 2 'either) cross(i(\"VVIN:p\" ?result 'dc) 0 3 'either))))")

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











