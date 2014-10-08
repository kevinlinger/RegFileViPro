/*
 Ocean script to measure bitcell write margin by sweeping WL voltage
  on both access transistors
 
 Author		Jiajing Wang 
  
 Date		05/23/2010
 Modified by      RWM
*/

; ************************** main code ***************************
simulator( 'spectre )
(envSetVal "spectre.opts" "multithread" 'string "on")
(envSetVal "spectre.opts" "nthreads" 'string "3")

;; DATA PATTEN: '0' OR '1' OR Both
;;DATYPE = <pdat> 
DATYPE = 2
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

foreach( DAT DATList

    design( "./netlist" )

    resultsDir( sprintf(nil "./OUT/DAT%L" DAT) )

    modelFile( 
	'("<include>")
	'("<subN>")
	'("<subP>")
    )

;;rwm added VSS VBL WLV LBL
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

 desVar(	  "pdvtar" <pdvtar>	)
 desVar(	  "pdvtal" <pdvtal>	)
 desVar(	  "pgvtar" <pgvtar>	)
 desVar(	  "pgvtal" <pgvtal>	)
 desVar(	  "puvtar" <puvtar>	)
 desVar(	  "puvtal" <puvtal>	)

    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd" VDD    )
    desVar(   "pvbp" <pvbp> )
    desVar(   "wlv"  <wlv>  )
    desVar(   "pvbn" <pvbn> )
    desVar(   "pvdda" <pvdda>    )
    desVar(   "pvss" VSS    )
    desVar(   "lbl" <lbl>   )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )
    desVar(   "pvin" 0    )

    if( DAT==0 then
      desVar(  "pvbl" VBL )
      desVar(  "pvblb" LBL )
      nodeset( "ICell.Q" 0 )
      nodeset( "ICell.QB" VDD )
    else 
      desVar(  "pvbl" LBL )
      desVar(  "pvblb" VBL )
      nodeset( "ICell.Q" VDD )
      nodeset( "ICell.QB" 0 )
    )

    monteCarlo( ?startIter <mcStartNum> ?numIters <mcrunNum> 
		?analysisVariation variationType
                ?sweptParam "None" ?sweptParamVals "27" ?saveData nil 
                ?append nil ?nomRun nil)
    
    analysis('dc ?param "pvin" ?start "0" ?stop WLV*1.5 ?step 0.001)
    temp( <temp> ) 
    option( 'reltol 1e-6 'gmin <gmin> )
    delete('save)
    save( 'v "ICell.Q" "ICell.QB" "WL" "VDD" "VBL" "wlv" )
    saveOption( 'save "selected" )

    ;;Measure WL margin- rwm changed <pvdd> to <wlv>
    if( DAT==0 then
      monteExpr( "WMWL" "<wlv> - cross(v(\"ICell.Q\" ?result 'dc)-v(\"ICell.QB\" ?result 'dc) 0.001 1 'either)" )
   
    ;; Checking the voltage difference between QB and Q when VWL=VDD.
    ;; This checking is needed since Q and QB might not cross over during WL
    ;;   sweeping but start from the value opposite to the initial node
    ;;   setting and maintain that value all the time.  
    ;; It occurs when the cell's write ability is so strong that Q 
    ;;   and QB flip before rising WL (e.g. using write assist such as drooping cell VDD).
    ;; In this case, write margin should be equal to VDD although the measured
    ;;   data is zero/nil because of no cross-over point.
      monteExpr( "WM_QBmQ" "value(v(\"ICell.QB\" ?result 'dc) <wlv>)-value(v(\"ICell.Q\" ?result 'dc) <wlv>)" )

    else 
      monteExpr( "WMWL" "<wlv> - cross(v(\"ICell.QB\" ?result 'dc)-v(\"ICell.Q\" ?result 'dc) 0.001 1 'either)" )
      monteExpr( "WM_QmQB" "value(v(\"ICell.Q\" ?result 'dc) <wlv>)-value(v(\"ICell.QB\" ?result 'dc) <wlv>)" )

    )

    ;; Measure the Vth0
    monteExpr( "VT_PL" "pv(\"ICell.MPl.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_PR" "pv(\"ICell.MPr.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_NL" "pv(\"ICell.MNl.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_NR" "pv(\"ICell.MNr.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_TL" "pv(\"ICell.MTl.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_TR" "pv(\"ICell.MTr.NX.<nModelName>\" \"vtho\" ?result 'model)" )
   
    monteRun()

    delete('monteExpr)
    delete('monteCarlo)

);end foreach(DAT









