;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 45 nm ST045
;;
;; Satyanand Vijay Nalam -- 01/09/07
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; SET SIMULATOR
simulator( 'spectre )

;; SET DESIGN
design( "netlist" )

resultsDir( "./OUT/DAT" )

modelFile(
	'("<include>")
	'("<subN>")
	'("<subP>")
	'("<subPU>")
	'("<subPD>")
	'("<subPG>")

)
desVar(       "wpu" <wpu>   )
desVar(       "lpu" <lpu>   )
desVar(       "wpd" <wpd>   )
desVar(       "lpd" <lpd>   )
desVar(       "wpg" <wpg>   )
desVar(       "lpg" <lpg>   )

desVar( "pvdd" <pvdd> )
desVar( "wdef" <wdef> )
desVar( "ldef" <ldef> )
desVar( "numRows2" <numRows2>)
desVar( "cap" 0.1e-15*<numRows2>)

analysis( 'tran ?start 0 ?stop 500p ?step 1p ?errpreset 'conservative )
temp( <temp> )
option( 'reltol 1e-6 'gmin <gmin> )
save('all)
run()
selectResult('tran)
