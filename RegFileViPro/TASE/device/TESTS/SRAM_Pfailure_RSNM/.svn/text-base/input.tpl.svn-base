simulator( 'spectre )
(envSetVal "spectre.opts" "multithread" 'string "on")
(envSetVal "spectre.opts" "nthreads" 'string "3")

design(	 "./netlist")
modelFile(
    '("<include>")
    '("<subN>")
    '("<subP>")
    '("<subPU>")
    '("<subPD>")
    '("<subPG>")
)

;; MONTE CARLO ITERATION NUMBER
nIt = <mcrunNum>

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

VDD_SWEEP = <pvdd>

desVar(       "wpu" <wpu>   )
desVar(       "lpu" <lpu>   )
desVar(       "wpd" <wpd>   )
desVar(       "lpd" <lpd>   )
desVar(       "wpg" <wpg>   )
desVar(       "lpg" <lpg>   )

desVar(   "ldef" <ldef> )
desVar(   "wdef" <wdef> )
desVar(   "pvdd" <pvdd> )
desVar(   "minl" <minl> )
desVar(   "minw" <minw> )

for(i 0 3 
	VDD = <pvdd>/2+ i*<VDDstep>

	resultsDir(sprintf(nil "./OUT/RSNM%d" i))

	desVar(   "pvdd" VDD )
	desVar(   "pvIn" VDD )

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Monte Carlo Simulation
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	monteCarlo( ?startIter <mcStartNum> ?numIters nIt ?analysisVariation variationType ?sweptParam "None" ?sweptParamVals "27" ?saveData nil ?append nil ?nomRun nil)

	analysis( 'dc ?param "pvIn" ?start -VDD ?stop VDD ?step "0.001" )
	temp( <temp> ) 
	option( 'reltol <reltol> 'gmin <gmin> )

	;; Measurement
	monteExpr( "RSNMh" "ymax(clip(v(\"v1mv2h\" ?result 'dc) nil 0))/sqrt(2)*1e3")
	monteExpr( "RSNMl" "ymin(clip(v(\"v1mv2h\" ?result 'dc) 0 nil))/sqrt(2)*(-1)*1e3")

	monteRun()

	delete('monteExpr)
	delete('monteCarlo)
)
