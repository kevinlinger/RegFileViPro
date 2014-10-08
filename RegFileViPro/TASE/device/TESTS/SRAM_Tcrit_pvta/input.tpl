;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RUN SIMULATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; NOTE: TP changed to 10*maxp; This means that the value of Q and QB
;; is checked after 10 cycles

simulator( 'spectre )
(envSetVal "spectre.opts" "multithread" 'string "on")
(envSetVal "spectre.opts" "nthreads" 'string "3")


;; Transistors to sweep: 1-PUL; 2-PDL; 3-PGL; 4-PUR; 5-PDR; 6-PGR
DATList = '(4 5)

;; Main Loop
foreach( DAT DATList

	;; COPY THE CORRISPONDING NETLIST FOR THE DESIRED DATA PATTERN
	
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

	
	desVar(	  "vtpul"  0	)
	desVar(	  "vtpdl"  0	)
	desVar(	  "vtpgl"  0	)
	desVar(	  "vtpur"  0	)
	desVar(	  "vtpdr"  0	)
	desVar(	  "vtpgr"  0	)
	desVar(   "wpu"  <wpu>  )
	desVar(   "lpu"  <lpu>  )
	desVar(   "wpd"  <wpd>  )
	desVar(   "lpd"  <lpd>  )
	desVar(   "wpg"  <wpg>  )
	desVar(   "lpg"  <lpg>  )
	desVar(   "pr"   <pr> )
	desVar(   "pf"   <pf> )
	desVar(   "tp"   <tp>   )
	desVar(   "pvdd" <pvdd>  )
	desVar(   "pvbp" <pvbp>  )
	x=-0.1
	
	minpw = <minpw>
	min = minpw
	maxpw = <maxpw>
	max = maxpw
	tol = <tol>
	tp = 10*maxpw
	pvdd = <pvdd>
	done = 0

	out = outfile(sprintf(nil "Tcrit_wr%L.txt" DAT))

	while(x <= 0.1
		

		;; first check if cell is already flipped at min pw or cannot flip at max pw
		desVar("pw" minpw)
		if(DAT == 1 then
			desVar("vtpul"	x)
		)
		if(DAT == 2 then
			desVar("vtpdl"	x)
		)
		if(DAT == 3 then
			desVar("vtpgl"	x)
		)
		if(DAT == 4 then
			desVar("vtpur"	x)
		)
		if(DAT == 5 then
			desVar("vtpdr"	x)
		)
		if(DAT == 6 then
			desVar("vtpgr"	x)
		)

		analysis( 'tran ?start 0 ?stop 1.1*tp ?step tp/1000 ?strobeperiod tp/1000 ?errpreset 'conservative )
		temp(<temp>)

		run()
		
			

		selectResults('tran)
		
			diff = value(v("Q") tp) - value(v("QB") tp)
		
			
		if( (diff > 0.9*pvdd) then
			;;qDelay=cross(v("Q") pvdd*.98 1 'rising)
			;;qbDelay=cross(v("QB") pvdd*.02 1 'falling)
		        fprintf(out, "%e\t%e\n", minpw, x)
		        done = 1
		)

		if( (done == 0) then
			desVar("pw" maxpw)

			analysis( 'tran ?start 0 ?stop 1.1*tp ?step tp/1000 ?strobeperiod tp/1000 ?errpreset 'conservative )
			temp(<temp>)

	   		run()
	        	
		        selectResults('tran)
			

                        	diff = value(v("Q") tp) - value(v("QB") tp)
                        	
			if( (diff < 0.9*pvdd) then
				;cell not flipped at maxpw, instead of infinite use 1.5maxpw
		        	fprintf(out, "%e\t%e\n", 1.5*maxpw,x)
			        done = 1
			)
		)

		;; After taking care of the extremes, the binary search routine can begin

		while( done == 0
			while( (max-min) >= tol
				desVar("pw" (min+max)/2)
				pw = (min+max)/2
				
			        analysis( 'tran ?start 0 ?stop 1.1*tp ?step tp/1000 ?strobeperiod tp/1000 ?errpreset 'conservative )
		                temp(<temp>)
	                
		                run()
	                
		                selectResults('tran)
					
                        		diff = value(v("Q") tp) - value(v("QB")  tp)
                        		

				;; if flipped upper limit of search window moves to mid-point.
				;; if not flipped lower limit of search window moves to mid-point.
				if( (diff > 0.9*pvdd) then
					;;qDelay=cross(v("Q") pvdd*.98 1 'rising)
					;;qbDelay=cross(v("QB") pvdd*.02 1 'falling)
					max = (max+min)/2
				else
					min = (max+min)/2
				)
			)
			
			done = 1
			fprintf(out, "%e\t%e\n", pw,x)
		)

		; reset done, min and max
		done = 0
		min = minpw
		max = maxpw 
		drain(out)
		x=x+0.02
	)
	close(out)
)
