/*
 Ocean script to measure bitcell write margin by VTC curves
 
 Author		Jiajing Wang   
 Date		02/11/2008
 Modified by
*/

; ************************** main code ***************************
simulator( 'spectre )
(envSetVal "spectre.opts" "multithread" 'string "on")
(envSetVal "spectre.opts" "nthreads" 'string "3")


DATList = '(1 2 3 4 5 6)

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

    VDD_sweep = <pvdd>
    
    desVar(	  "vtpul"  0	)
    desVar(	  "vtpdl"  0	)
    desVar(	  "vtpgl"  0	)
    desVar(	  "vtpur"  0	)
    desVar(	  "vtpdr"  0	)
    desVar(	  "vtpgr"  0	)
    desVar(	  "wpu" <wpu>	)
    desVar(	  "lpu" <lpu>	)
    desVar(	  "wpd" <wpd>	)
    desVar(	  "lpd" <lpd>	)
    desVar(	  "wpg" <wpg>	)
    desVar(	  "lpg" <lpg>	)

    desVar(   "ldef" <ldef> )
    desVar(   "wdef" <wdef> )
    desVar(   "pvdd"   <pvdd>    )
    desVar(   "pvdda"  <pvdda> )
    desVar(   "pvddwl" <pvddwl> )
    desVar(   "pvin" 0      )
    desVar(   "minl" <minl> )
    desVar(   "minw" <minw> )
    x=-0.2

out = outfile(sprintf(nil "WM_SNM%L.txt" DAT))

;;;;;;;;;;;; MC ;;;;;;;;;;;;;;;;;;;  
while(x <= 0.2

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

    analysis('dc ?param "pvin" ?start (-1)*VDD_sweep*sqrt(2)/2 ?stop VDD_sweep*sqrt(2)/2 ?step 0.001)
    temp( <temp> )
    option( 'reltol 1e-6 'gmin <gmin> )

    run()
    selectResults('dc)

    ;; The trip voltage of the read VTC curve
    VM=value(v("v1") 0)/sqrt(2)
    ;; The voltage of node '1' when input is 0
    VOH_inv1=cross( (v("v2")-v("U")) 0 1 'falling)*sqrt(2)
    ;; The smallest square (note: v2 should be clipped to be smaller than VOH_inv1)
    WM=ymin(clip(v("v1mv2") 0 cross(v("v2")-v("U") 0 1 'falling)))/sqrt(2)

    fprintf(out, "%e\t%e\t%e\n", VM,VOH_inv1,WM)

    x=x+0.02

);;end while
close(out)

);; end for







