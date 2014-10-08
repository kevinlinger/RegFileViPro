; Jiajing Wang, 2008-01-29
; Characterize 6T cell Data Retention Voltage.

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
desVar(   "pvdd" <pvdd> )
desVar(   "minl" <minl> )
desVar(   "minw" <minw> )

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

;; Measure DRV0
monteExpr( "ILK_VDD" "abs(value(i(\"_VDD:p\" ?result 'dc) <pvdd>))" )    
monteExpr( "ILK_BL" "abs(value(i(\"_VBL:p\" ?result 'dc) <pvdd>))" )
monteExpr( "ILK_VSS" "abs(value(i(\"_VSS:p\" ?result 'dc) <pvdd>))" )
monteExpr( "PLK" "value(getData(\":pwr\" ?result 'dc) <pvdd>)" )
;monteExpr( "ILK_VDD_2" "abs(value(i(\"_VDD:p\" ?result 'dc) 0.3))" )    
;monteExpr( "ILK_BL_2" "abs(value(i(\"_VBL:p\" ?result 'dc) 0.3))" )
;monteExpr( "ILK_VSS_2" "abs(value(i(\"_VSS:p\" ?result 'dc) 0.3))" )
;monteExpr( "PLK_2" "value(getData(\":pwr\" ?result 'dc) 0.3)" )

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
