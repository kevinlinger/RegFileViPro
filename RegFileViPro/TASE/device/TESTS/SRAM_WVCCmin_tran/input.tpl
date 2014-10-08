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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

    VDD = <pvdd>
    
    desVar(	  "wpu" <wpu>	)
    desVar(	  "lpu" <lpu>	)
    desVar(	  "wpd" <wpd>	)
    desVar(	  "lpd" <lpd>	)
    desVar(	  "wpg" <wpg>	)
    desVar(	  "lpg" <lpg>	)

    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )
    
    minvdd = 5e-3
    min = minvdd
    maxvdd = <pvdd>
    max = maxvdd
    tol = 20e-3
    done = 0

    if( DAT==0 then
	mult = 1
    else
	mult = -1
    )
    
    of = outfile(sprintf(nil "wvmin%L.txt" DAT) "w")
    for(i <startIter> <stopIter>
    
	    desVar(   "pvdd" minvdd    )
	    VDD=minvdd
	    monteCarlo( ?startIter i ?numIters 1 
			?analysisVariation variationType
                	?sweptParam "None" ?sweptParamVals "27" ?saveData nil 
                	?append nil ?nomRun nil)

	    analysis('tran ?start 0 ?stop 100u ?strobeperiod 0.1u ?errpreset 'moderate)
	    temp( <temp> ) 
	    option( 'reltol 1e-6 'gmin <gmin> )

	    monteRun()

	    delete('monteExpr)
	    delete('monteCarlo)
	    
	    selectResult('tran)
	    diff = mult*(value(value(v("ICell.Q") 'iteration i) 100u) - value(value(v("ICell.QB") 'iteration i) 100u))
	    if(diff > 0.99*VDD then
	    	fprintf(of, "%e\n", minvdd)	
		done=1
	    )
	    
            if( (done == 0) then
	    	desVar("pvdd" maxvdd)
		VDD = maxvdd
		monteCarlo( ?startIter i ?numIters 1 
			?analysisVariation variationType
                	?sweptParam "None" ?sweptParamVals "27" ?saveData nil 
                	?append nil ?nomRun nil)

	    	analysis('tran ?start 0 ?stop 100u ?strobeperiod 0.1u ?errpreset 'moderate)
	    	temp( <temp> ) 
	    	option( 'reltol 1e-6 'gmin <gmin> )

	    	monteRun()

	    	delete('monteExpr)
	    	delete('monteCarlo)
		
	    	selectResult('tran)
	    	diff = mult*(value(value(v("ICell.Q") 'iteration i) 100u) - value(value(v("ICell.QB") 'iteration i) 100u))
	    	if(diff < 0.99*VDD then
	    		fprintf(of, "%e\n", maxvdd)	
			done=1
	   	 )
     	    )
	    
	    
	    while( done == 0
	    	while( (max-min) >=tol
		
			desVar("pvdd" (min+max)/2)
			VDD = (min+max)/2
			monteCarlo( ?startIter i ?numIters 1 
				?analysisVariation variationType
                		?sweptParam "None" ?sweptParamVals "27" ?saveData nil 
                		?append nil ?nomRun nil)
			
			analysis('tran ?start 0 ?stop 100u ?strobeperiod 0.1u ?errpreset 'moderate)
	    		temp( <temp> ) 
	    		option( 'reltol 1e-6 'gmin <gmin> )

	    		monteRun()

	    		delete('monteExpr)
	    		delete('monteCarlo)
			
	    		selectResult('tran)
			diff = mult*(value(value(v("ICell.Q") 'iteration i) 100u) - value(value(v("ICell.QB") 'iteration i) 100u))
			if( (diff > 0.99*VDD) then
				max = (max+min)/2
			else
				min = (max+min)/2
			)		
		)
		done = 1
		fprintf(of, "%e\n", VDD)	    
	    )
	    
	    done=0
	    min=minvdd
	    max=maxvdd
	    drain(of)
    )
    close(of)
)
