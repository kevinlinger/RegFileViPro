
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
desVar(   "minl" <minl> )
desVar(   "minw" <minw> )
desVar(   "cap5"  0.1e-15*<numRows>)
desVar(   "cap6"  0.1e-15*2*<numRows>)
desVar(   "pw"   <pw>   )
desVar(   "pr"   <pr>   )
desVar(   "pf"   <pf>   )

pvdd = <pvdd>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;; ;;;;;;;;;;;; ;;;;;;;;;;;; 

;;Read 0 MC
;6T
ic( "BL" pvdd "BLB" pvdd "IA6T.QB" pvdd "IA6T.Q" 0 "ID6T.QB" 0 "ID6T.Q" pvdd)
;5T
ic( "BL1" pvdd "BL2" pvdd "IA5T.QB" pvdd "IA5T.Q" 0 "ID1.QB" 0 "ID1.Q" pvdd "IREF2.Q" 0 "IREF2.QB" pvdd "ID2.QB" pvdd "ID2.Q" 0)
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
;monteExpr("deltaVBL0_6T" "value(v(\"BLB\" ?result 'tran) <pw>) - value(v(\"BL\" ?result 'tran) <pw>)")
;monteExpr("deltaVBL0_5T" "value(v(\"BL2\" ?result 'tran) <pw>) - value(v(\"BL1\" ?result 'tran) <pw>)")
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
ic( "BL1" pvdd "BL2" pvdd "IA5T.Q" pvdd "IA5T.QB" 0 "ID1.Q" 0 "ID1.QB" pvdd "IREF2.Q" 0 "IREF2.QB" pvdd "ID2.Q" pvdd "ID2.QB" 0)
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
;monteExpr("deltaVBL1_6T" "value(v(\"BL\" ?result 'tran) <pw>) - value(v(\"BLB\" ?result 'tran) <pw>)")
;monteExpr("deltaVBL1_5T" "value(v(\"BL1\" ?result 'tran) <pw>) - value(v(\"BL2\" ?result 'tran) <pw>)")
monteExpr("VBL2" "value(v(\"BL2\" ?result 'tran) <pw>)")
monteExpr("VBL1" "value(v(\"BL1\" ?result 'tran) <pw>)")
monteExpr("VBL" "value(v(\"BL\" ?result 'tran) <pw>)")
monteExpr("VBLB" "value(v(\"BLB\" ?result 'tran) <pw>)")

monteRun()
delete('monteExpr)
delete('monteCarlo)
