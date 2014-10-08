
; ************************** main code ***************************
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
    desVar(    "wpu1" <wpu1>   )
    desVar(    "lpu1" <lpu1>   )
    desVar(    "wpu2" <wpu2>   )
    desVar(    "lpu2" <lpu2>   )
    desVar(    "wpd1" <wpd1>   )
    desVar(    "lpd1" <lpd1>   )
    desVar(    "wpd2" <wpd2>   )
    desVar(    "lpd2" <lpd2>   )
    desVar(    "wax" <wax>   )
    desVar(    "lax" <lax>   )


desVar(       "wpu" <wpu>   )
desVar(       "lpu" <lpu>   )
desVar(       "wpd" <wpd>   )
desVar(       "lpd" <lpd>   )
desVar(       "wpg" <wpg>   )
desVar(       "lpg" <lpg>   )

desVar(   "numRows" <numRows> )
desVar(   "ldef" <ldef> )
desVar(   "wdef" <wdef> )
desVar(   "pvdd" <pvdd> )
desVar(   "pvddl" <pvddl> )
desVar(   "cbl"  0.1e-15)
desVar(   "pw"   <pw>   )
desVar(   "pr"   <pr>   )
desVar(   "pf"   <pf>   )

pvdd = <pvdd>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;; ;;;;;;;;;;;; ;;;;;;;;;;;; 

;;Read 0 MC
;6T
ic( "BL" pvdd "BLB" pvdd "IA6T.QB" pvdd "IA6T.Q" 0 "ID6T.QB" 0 "ID6T.Q" pvdd)

;5T
ic( "BL1" pvdd "BL2" pvdd "IA5T.QB" pvdd "IA5T.Q" 0 "ID5T1.QB" 0 "ID5T1.Q" pvdd "IREF2.Q" 0 "IREF2.QB" pvdd "ID5T2.QB" pvdd "ID5T2.Q" 0)
ic(  "IREF1.Q" pvdd "IREF1.QB" 0)

resultsDir("./OUT/DAT0")

;;;;;;;;;;; MC 
monteCarlo( ?startIter <mcStartNum> ?numIters <mcrunNum>
        ?analysisVariation variationType
        ?sweptParam "None" ?sweptParamVals "27" ?saveData nil
        ?append nil ?nomRun t)
analysis( 'tran ?start 0 ?stop 2*<pw> ?step <pw>/100 ?strobeperiod <pw>/100 ?errpreset 'conservative )
temp( <temp> )
option( 'reltol 1e-6 'gmin <gmin> )

;;;;;;; Measurement
monteExpr("dly5" "cross(v(\"BL2\" ?result 'tran)-v(\"BL1\" ?result 'tran) <BLdiff> 1 'rising) - cross(v(\"WLA5T\" ?result 'tran) pvdd/2 1 'rising)")
monteExpr("dly6" "cross(v(\"BLB\" ?result 'tran)-v(\"BL\" ?result 'tran) <BLdiff> 1 'rising) - cross(v(\"WLA6T\" ?result 'tran) pvdd/2 1 'rising)")
monteExpr("VBL2" "value(v(\"BL2\" ?result 'tran) <pw>)")
monteExpr("VBL1" "value(v(\"BL1\" ?result 'tran) <pw>)")
monteExpr("VBL" "value(v(\"BL\" ?result 'tran) <pw>)")
monteExpr("VBLB" "value(v(\"BLB\" ?result 'tran) <pw>)")

monteRun()
delete('monteExpr)
delete('monteCarlo)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;; ;;;;;;;;;;;; ;;;;;;;;;;;;

;;Read 1 MC
;6T
ic( "BL" pvdd "BLB" pvdd "IA6T.Q" pvdd "IA6T.QB" 0 "ID6T.Q" 0 "ID6T.QB" pvdd)
;5T
ic( "BL1" pvdd "BL2" pvdd "IA5T.Q" pvdd "IA5T.QB" 0 "ID5T1.Q" 0 "ID5T1.QB" pvdd "IREF2.Q" 0 "IREF2.QB" pvdd "ID5T2.Q" pvdd "ID5T2.QB" 0)
ic(  "IREF1.Q" 0 "IREF1.QB" pvdd)

resultsDir("./OUT/DAT1")

;;;;;;;;;;;; MC
monteCarlo( ?startIter <mcStartNum> ?numIters <mcrunNum>
        ?analysisVariation variationType
        ?sweptParam "None" ?sweptParamVals "27" ?saveData nil
        ?append nil ?nomRun t)
analysis( 'tran ?start 0 ?stop 2*<pw> ?step <pw>/100 ?strobeperiod <pw>/100 ?errpreset 'conservative )
temp( <temp> )
option( 'reltol 1e-6 'gmin <gmin> )

;;;;;;; Measurement
monteExpr("dly5" "cross(v(\"BL1\" ?result 'tran)-v(\"BL2\" ?result 'tran) <BLdiff> 1 'rising) - cross(v(\"WLA5T\" ?result 'tran) pvdd/2 1 'rising)")
monteExpr("dly6" "cross(v(\"BL\" ?result 'tran)-v(\"BLB\" ?result 'tran) <BLdiff> 1 'rising) - cross(v(\"WLA6T\" ?result 'tran) pvdd/2 1 'rising)")
monteExpr("VBL2" "value(v(\"BL2\" ?result 'tran) <pw>)")
monteExpr("VBL1" "value(v(\"BL1\" ?result 'tran) <pw>)")
monteExpr("VBL" "value(v(\"BL\" ?result 'tran) <pw>)")
monteExpr("VBLB" "value(v(\"BLB\" ?result 'tran) <pw>)")

monteRun()
delete('monteExpr)
delete('monteCarlo)
