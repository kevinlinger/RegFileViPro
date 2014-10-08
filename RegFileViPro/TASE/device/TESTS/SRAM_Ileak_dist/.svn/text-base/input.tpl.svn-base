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
    '("<subPG>")
    '("<subPD>")
    '("<subPU>")
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
    VSS= <pvss>
    VBL= <bitline>
    WLV= <wlv>
    LBL= <lbl>

desVar(	  "wpu" <wpu>	)
desVar(	  "lpu" <lpu>	)
desVar(	  "wpd" <wpd>	)
desVar(	  "lpd" <lpd>	)
desVar(	  "wpg" <wpg>	)
desVar(	  "lpg" <lpg>	)

desVar(   "ldef" <ldef> )
desVar(   "wdef" <wdef> )
desVar(   "pvdd" <pvdd> )
desVar(   "minl" <minl> )
desVar(   "minw" <minw> )
desVar(   "pvdd" VDD    )
    desVar(   "pvbp" <pvbp> )
    desVar(   "wlv"  <wlv>  )
    desVar(   "pvbn" <pvbn> )
    desVar(   "pvdda" <pvdda>    )
    desVar(   "pvss" VSS    )
    desVar(   "lbl" <lbl>   )
    desVar(   "bitline" <bitline>   )

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
monteExpr( "ILK_BLB" "abs(value(i(\"_VBLB:p\" ?result 'dc) <pvdd>))" )
monteExpr( "ILK_VSS" "abs(value(i(\"_VSS:p\" ?result 'dc) <pvdd>))" )
monteExpr( "PLK" "value(getData(\":pwr\" ?result 'dc) <pvdd>)" )
monteExpr( "ILK_VDD_2" "abs(value(i(\"_VDD:p\" ?result 'dc) 0.3))" )    
monteExpr( "ILK_BL_2" "abs(value(i(\"_VBL:p\" ?result 'dc) 0.3))" )
monteExpr( "ILK_BLB_2" "abs(value(i(\"_VBLB:p\" ?result 'dc) 0.3))" )
monteExpr( "ILK_VSS_2" "abs(value(i(\"_VSS:p\" ?result 'dc) 0.3))" )
monteExpr( "PLK_2" "value(getData(\":pwr\" ?result 'dc) 0.3)" )

;;modelParameter info what=models where=rawfile
;; Measure the Vth0
monteExpr( "VT_PL" "pv(\"ICell.ICellLh.MP.PX.<puModelName>\" \"vtho\" ?result 'model)" )
monteExpr( "VT_PR" "pv(\"ICell.ICellRh.MP.PX.<puModelName>\" \"vtho\" ?result 'model)" )
monteExpr( "VT_NL" "pv(\"ICell.ICellLh.MN.NX.<pdModelName>\" \"vtho\" ?result 'model)" )
monteExpr( "VT_NR" "pv(\"ICell.ICellRh.MN.NX.<pdModelName>\" \"vtho\" ?result 'model)" )
monteExpr( "VT_TL" "pv(\"ICell.ICellLh.MT.NX.<pgModelName>\" \"vtho\" ?result 'model)" )
monteExpr( "VT_TR" "pv(\"ICell.ICellRh.MT.NX.<pgModelName>\" \"vtho\" ?result 'model)" )


monteRun()

delete('monteExpr)
delete('monteCarlo)

