/*
 Ocean script to measure bitcell write margin by sweeping WL voltage
 
 Author		Jiajing Wang   
 Date		02/11/2008
 Modified by
*/

;;;; function to exchange x and y axis
load("abChangeXAxis.il")

; ************************** main code ***************************
simulator( 'spectre )

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
	'("<subPU>")
	'("<subPD>")
	'("<subPG>")
    )

    VDD = <pvdd>
    
    desVar(	  "wpu" <wpu>	)
    desVar(	  "lpu" <lpu>	)
    desVar(	  "wpd" <wpd>	)
    desVar(	  "lpd" <lpd>	)
    desVar(	  "wpg" <wpg>	)
    desVar(	  "lpg" <lpg>	)

    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd" VDD    )
    desVar(   "pvbp" VDD    )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )
    desVar(   "pvin" 0    )

    ;; The input file contains VM of the inverter connecting '0' initially
    ;;  VM is the first saved data from the test 'SRAM_WM_SNM'
    ;;  So 'SRAM_WM_SNM' test must be run before this test
    in = infile( sprintf(nil "../SRAM_WM_SNM/OUT/DAT%L/monteCarlo/mcdata" DAT) )
    of = outfile( sprintf(nil "./OUT/vwl_d%L.out" DAT) "w")     
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MC ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;;; Have to save each iteration since VM is unable to set during simulation
;;; So divide the large sample pool into several runs to reduce the required 
;;;   saving space 

  if( nIt>100 then
    res=mod(nIt,100)
    if( res>0 then
        print("MC iteration # is not multiples of 100!")
	exit
    else   
        mcNum=100
        lpNum=nIt/100  ;; Make sure nIt is multiples of 100
    )
  else
    mcNum=nIt
    lpNum=1
  )

  for(k 1 lpNum
    startNum= <mcStartNum>+(k-1)*mcNum

    monteCarlo( ?startIter startNum ?numIters mcNum 
		?analysisVariation variationType
                ?sweptParam "None" ?sweptParamVals "27" ?saveData t
                ?append nil ?nomRun nil)
    
    analysis('dc ?param "pvin" ?start "0" ?stop VDD ?step 0.001)
    temp( <temp> ) 
    option( 'reltol 1e-6 'gmin <gmin> )
    delete('save)
    save( "Q" "QB_OUT" "WL1" )
    saveOption( 'save "selected" )

    ;;Measure VOL
    monteExpr( "VOL" "value(v(\"Q\" ?result 'dc) 0)" )
   
    ;; Measure the Vth0
    monteExpr( "VT_PL" "pv(\"ICellL.MP.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_PR" "pv(\"ICellR.MP.PX.<pModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_NL" "pv(\"ICellL.MN.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_NR" "pv(\"ICellR.MN.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_TL" "pv(\"ICellL.MT.NX.<nModelName>\" \"vtho\" ?result 'model)" )
    monteExpr( "VT_TR" "pv(\"ICellR.MT.NX.<nModelName>\" \"vtho\" ?result 'model)" )
   
    monteRun()

    selectResults('dc)

    ;; Post-processing each iteration
    for(i 1 mcNum
      it = <mcStartNum>-1+(k-1)*mcNum+i
      VOL = value(value(v("Q") 'iteration it) 0)
      VQB = value(v("QB_OUT") 'iteration it) ;one waveform
      VWL = value(v("WL1") 'iteration it)    ;another waveform

      ;; get VM
      VM = car(lineread(in))

      ;; get the WL voltage value when QB_OUT is VM 
      c=abChangeXAxis( VWL VQB )

      ;; get write margin
      WM = VDD - value(c VM)
      fprintf(of "%8.3g\t%8.3g\t%8.3g\n" VOL VM WM)
    )

    delete('monteExpr)
    delete('monteCarlo)

  ) ; for(k 1 lpNum)

  drain( of )
  close( of )

);end foreach(DAT









