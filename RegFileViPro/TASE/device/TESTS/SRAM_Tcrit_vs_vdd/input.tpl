;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RUN SIMULATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ************************** main code ***************************
simulator( 'spectre )
(envSetVal "spectre.opts" "multithread" 'string "on")
(envSetVal "spectre.opts" "nthreads" 'string "3")

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

;; Define pvdd list
vddList = '(0.5 0.6 0.7 0.8 0.9 1)

foreach( vdd vddList

;; Main Loop
foreach( DAT DATList

	;; COPY THE CORRISPONDING NETLIST FOR THE DESIRED DATA PATTERN
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

	desVar(   "wpu"  <wpu>  )
	desVar(   "lpu"  <lpu>  )
	desVar(   "wpd"  <wpd>  )
	desVar(   "lpd"  <lpd>  )
	desVar(   "wpg"  <wpg>  )
	desVar(   "lpg"  <lpg>  )
	desVar(   "pr"   <pr> )
	desVar(   "pf"   <pf> )
	desVar(   "tp"   <tp>   )
	desVar(   "pvbp" vdd  )
	desVar(   "pvdd" vdd )
	pvdd=vdd
	minpw = <minpw>/vdd**4
	min = minpw
	maxpw = <maxpw>/vdd**4
	max = maxpw
	tol = <tol>
	tp = <tp>
	
	done = 0

	out = outfile(sprintf(nil "Tcrit_wr%L_vdd_%L.txt" DAT vdd))

	for(i <startIter> <stopIter>
		;; first check if cell is already flipped at min pw or cannot flip at max pw
		desVar("pw" minpw)
		monteCarlo(?startIter i ?numIters 1 ?analysisVariation variationType ?sweptParam "None" ?sweptParamVals "27" ?saveData nil ?append nil ?nomRun nil)
		analysis( 'tran ?start 0 ?stop 1.1*tp ?step tp/1000 ?strobeperiod tp/1000 ?errpreset 'conservative )
		temp(<temp>)

		monteRun()
		delete('monteExpr)
		delete('monteCarlo)

		selectResults('tran)
		if( (DAT == 0)
			diff = value(value(v("Q") 'iteration i) tp) - value(value(v("QB") 'iteration i) tp)
			diff = value(value(v("QB") 'iteration i) tp) - value(value(v("Q") 'iteration i) tp)
		)
			
		if( (diff > 0.9*pvdd) then
		        fprintf(out, "%e\n", minpw)
		        done = 1
		)

		if( (done == 0) then
			desVar("pw" maxpw)
			monteCarlo(?startIter i ?numIters 1 ?analysisVariation variationType ?sweptParam "None" ?sweptParamVals "27" ?saveData nil ?append nil ?nomRun nil)
			analysis( 'tran ?start 0 ?stop 1.1*tp ?step tp/1000 ?strobeperiod tp/1000 ?errpreset 'conservative )
			temp(<temp>)

	   		monteRun()
	        	delete('monteExpr)
	        	delete('monteCarlo)

		        selectResults('tran)
			if( (DAT == 0)
                        	diff = value(value(v("Q") 'iteration i) tp) - value(value(v("QB") 'iteration i) tp)
                        	diff = value(value(v("QB") 'iteration i) tp) - value(value(v("Q") 'iteration i) tp)
                )
			if( (diff < 0.9*pvdd) then
				;cell not flipped at maxpw, instead of infinite use 1.5maxpw
		        	fprintf(out, "%e\n", 1.5*maxpw)
			        done = 1
			)
		)

		;; After taking care of the extremes, the binary search routine can begin

		while( done == 0
			while( (max-min) >= tol
				desVar("pw" (min+max)/2)
				pw = (min+max)/2
				monteCarlo(?startIter i ?numIters 1 ?analysisVariation variationType ?sweptParam "None" ?sweptParamVals "27" ?saveData nil ?append nil ?nomRun nil)
			        analysis( 'tran ?start 0 ?stop 1.1*tp ?step tp/1000 ?strobeperiod tp/1000 ?errpreset 'conservative )
		                temp(<temp>)
	                
		                monteRun()
		                delete('monteExpr)
		                delete('monteCarlo)
	                
		                selectResults('tran)
				if( (DAT == 0)	
                        		diff = value(value(v("Q") 'iteration i) tp) - value(value(v("QB") 'iteration i) tp)
                        		diff = value(value(v("QB") 'iteration i) tp) - value(value(v("Q") 'iteration i) tp)
                		)

				;; if flipped upper limit of search window moves to mid-point.
				;; if not flipped lower limit of search window moves to mid-point.
				if( (diff > 0.9*pvdd) then
					max = (max+min)/2
				else
					min = (max+min)/2
				)
			)
			done = 1
			fprintf(out, "%e\n", pw)
		)

		; reset done, min and max
		done = 0
		min = minpw
		max = maxpw 
		drain(out)
	)
	close(out)
)
)
