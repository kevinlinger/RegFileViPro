; Satya, 2008-10-10
; Characterize 5T cell Data Retention Voltage.

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

;; ZERO THRESHOLD WHEN CALCULATING CROSS POINT OF Q AND QB
ZeroThresh = 0.0001  ;0.1mV

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

;; DATA TYPE '0' OR '1'
DATATYPES = '(1 0)

VDD_SWEEP = <pvdd>

foreach( DTYPE DATATYPES
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

      ;;;; INITIALIZE NODE
      if( DTYPE==0 then			;HOLD DATA '0'
         nodeset( "ICell.Q" 0 )
         nodeset( "ICell.QB" "pvdd" )
      else 
         if( DTYPE==1 then              ;HOLD DATA '1'
         nodeset( "ICell.Q" "pvdd" )
         nodeset( "ICell.QB" 0 )
         )
      )
      resultsDir( sprintf(nil "./OUT/DRV%L" DTYPE) )

      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ; Monte Carlo Simulation
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      monteCarlo( ?startIter 1 ?numIters nIt ?analysisVariation variationType ?sweptParam "None" ?sweptParamVals "27" ?saveData nil ?append nil ?nomRun "no")

      analysis( 'dc ?param "pvdd" ?start VDD_SWEEP ?stop 0 ?step "-0.001" )
      ;save( 'v "ICell.Q" "ICell.QB" )
      temp( <temp> ) 
      option( 'reltol 1e-6 'gmin <gmin> )

      if( DTYPE==0 then
         ;; Measure DRV0
         monteExpr( "DRV0" "cross(v(\"ICell.QB\" ?result 'dc)-v(\"ICell.Q\" ?result 'dc) 0.0001 1 'falling)*1e3" )	     
      else
         ;; Measure DRV1
         monteExpr( "DRV1" "cross(v(\"ICell.Q\" ?result 'dc)-v(\"ICell.QB\" ?result 'dc) 0.0001 1 'falling)*1e3" )
      )

      ;; Measure the Vth0
      monteExpr( "VT_PL" "pv(\"ICell.ICellLh.MP.PX.<pModelName>\" \"vtho\" ?result 'model)" )
      monteExpr( "VT_PR" "pv(\"ICell.ICellRi.MP.PX.<pModelName>\" \"vtho\" ?result 'model)" )
      monteExpr( "VT_NL" "pv(\"ICell.ICellLh.MN.NX.<nModelName>\" \"vtho\" ?result 'model)" )
      monteExpr( "VT_NR" "pv(\"ICell.ICellRi.MN.NX.<nModelName>\" \"vtho\" ?result 'model)" )
      monteExpr( "VT_TL" "pv(\"ICell.ICellLh.MT.NX.<nModelName>\" \"vtho\" ?result 'model)" )
      

      monteRun()

      delete('monteExpr)
      delete('monteCarlo)

); end foreach
