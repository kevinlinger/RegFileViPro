
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
	)

	VDD = <pvdd>

	desVar(    "wp1" <wp1>   )
	desVar(    "lp1" <lp1>   )
	desVar(    "wp2" <wp2>   )
	desVar(    "lp2" <lp2>   )
	desVar(    "wn1" <wn1>   )
	desVar(    "ln1" <ln1>   )
	desVar(    "wn2" <wn2>   )
	desVar(    "ln2" <ln2>   )
	desVar(    "wna" <wna>   )
	desVar(    "lna" <lna>   )
        desVar(    "wrs" <wrs>   )
        desVar(    "lrs" <lrs>   )

	desVar(   "ldef" <ldef> )
	desVar(   "wdef" <wdef> )
	desVar(   "pvdd" <pvdd> )
	desVar(   "minl" <minl> )
	desVar(   "minw" <minw> )

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Monte Carlo Simulation
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	monteCarlo( ?startIter <mcStartNum> 
		    ?numIters <mcrunNum> 
		    ?analysisVariation variationType 
		    ?sweptParam "None" 
		    ?sweptParamVals "27" 
		    ?saveData nil 
		    ?append nil 
		    ?nomRun "no" )

	analysis( 'dc ?param "pvdd" ?start VDD ?stop 0 ?step "-0.1" )
	temp( <temp> ) 
	option( 'reltol 1e-6 'gmin <gmin> )
	saveOption( 'save "all"
		    'currents "all"
		    'pwr   "all"
		    'nestlvl       ""
		    ?outputParamInfo nil
		    ?elementInfo nil
		    ?primitivesInfo nil
		    ?subcktsInfo nil 
		    ?modelParamInfo t 
		    'subcktprobelvl 0 )

	;; Measure leakage
	monteExpr( "ILK_VDD" "abs(value(i(\"_VDD:p\" ?result 'dc) <pvdd>))" )    
	monteExpr( "ILK_BL" "abs(value(i(\"_VBL:p\" ?result 'dc) <pvdd>))" )
	monteExpr( "ILK_RRST" "abs(value(i(\"_VRRST:p\" ?result 'dc) <pvdd>))" )
	monteExpr( "ILK_VSS" "abs(value(i(\"_VSS:p\" ?result 'dc) <pvdd>))" )
	monteExpr( "PLK" "value(getData(\":pwr\" ?result 'dc) <pvdd>)" )

	;; Measure the Vth0
	;monteExpr( "VT_PL" "pv(\"ICell.ICellLh.MP.PX.<pModelName>\" \"vtho\" ?result 'model)" )
	;monteExpr( "VT_PR" "pv(\"ICell.ICellRh.MP.PX.<pModelName>\" \"vtho\" ?result 'model)" )
	;monteExpr( "VT_NL" "pv(\"ICell.ICellLh.MN.NX.<nModelName>\" \"vtho\" ?result 'model)" )
	;monteExpr( "VT_NR" "pv(\"ICell.ICellRh.MN.NX.<nModelName>\" \"vtho\" ?result 'model)" )
	;monteExpr( "VT_TL" "pv(\"ICell.ICellLh.MT.NX.<nModelName>\" \"vtho\" ?result 'model)" )
	;monteExpr( "VT_TR" "pv(\"ICell.ICellRh.MT.NX.<nModelName>\" \"vtho\" ?result 'model)" )

	monteRun()

	delete('monteExpr)
	delete('monteCarlo)

);end foreach(DAT
