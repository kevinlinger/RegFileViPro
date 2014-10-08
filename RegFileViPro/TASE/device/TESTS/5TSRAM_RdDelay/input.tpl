;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 45 nm ST045
;;
;; Satyanand Vijay Nalam -- 01/09/07
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; SET SIMULATOR
simulator( 'spectre )

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

;; SET DESIGN
design( "netlist" )

resultsDir( "./OUT/DAT" )

modelFile(
	'("<include>")
	'("<subN>")
	'("<subP>")
	'("<subPU>")
	'("<subPD>")
	'("<subPG>")
)

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
desVar( "pvdd" <pvdd> )
desVar( "prise" <prise>)
desVar("pfall" <pfall>)
desVar("pwidth" <pwidth>)
pvdd = <pvdd>

;;;;;;;;;;;; MC ;;;;;;;;;;;;;;;;;;;
monteCarlo( ?startIter <mcStartNum> ?numIters <mcrunNum>
	?analysisVariation variationType
	?sweptParam "None" ?sweptParamVals "27" ?saveData nil
	?append nil ?nomRun t)

analysis( 'tran ?start 0 ?stop 1.5*<pwidth> ?step 0.01*<pwidth> ?strobeperiod 0.01*<pwidth> ?errpreset 'conservative )
temp( <temp> )
option( 'reltol 1e-6 'gmin <gmin> )

;;;;;;; Measurement
monteExpr( "rd0Delay" "cross(abs(v(\"BL1\" ?result 'tran)) <vdroop> 1 'falling)" )
monteExpr( "Iavg" "average(i(\"VBL:p\" ?result 'tran))")
monteExpr( "Ipeak" "ymax(i(\"VBL:p\" ?result 'tran))")
;monteExpr( "Iavg" "average(i(\"I0.MTL:d\" ?result 'tran))")
;monteExpr( "Ipeak" "ymax(i(\"I0.MTL:d\" ?result 'tran))")

;;RUN montecarlo
monteRun()

;;delete prev monte carlo expressions before next loop
delete('monteExpr)
delete('monteCarlo)
