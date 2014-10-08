; ************************** main code ***************************
simulator( 'spectre )
(envSetVal "spectre.opts" "multithread" 'string "on")
(envSetVal "spectre.opts" "nthreads" 'string "3")

design(	 "./netlist")
modelFile( 
    '("<include>")
    '("<subN>")
    '("<subP>")
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
desVar(   "pvin" <pvdd> )

resultsDir( "./OUT" )

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
	    ?nomRun "yes" )

analysis( 'dc ?param "pvin" ?start 0 ?stop VDD ?step "0.1" )
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

;; Measure Iread and ripple
monteExpr( "Iread1" "value(i(\"ICell.MNL.NX:d\" ?result 'dc) <pvdd>)" )    
monteExpr( "Iread2" "value(i(\"ICell.MTL.NX:s\" ?result 'dc) <pvdd>)" )    
monteExpr( "Vreadbump" "value(v(\"ICell.Q\" ?result 'dc) <pvdd>)" )    

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
