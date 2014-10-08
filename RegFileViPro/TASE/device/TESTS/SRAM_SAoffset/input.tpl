simulator( 'spectre )
dir = "./"
design( "netlist")

modelFile(
    '("<include>")
    '("<subN>")
    '("<subP>")
    '("<subPU>")
    '("<subPD>")
    '("<subPG>")

)

offsetList = list(<offsetList>)

foreach( (offset) offsetList
	desVar( "offsetp" offset )

	sprintf(dir "./OUT%0.2f" offset)
	resultsDir( dir )

	analysis('tran ?stop 2*<sao_per> ?errpreset "conservative"  )
	desVar( "pvdd" <pvdd> )
	desVar( "ldef" <ldef> )
	desVar( "wdef" <wdef> )
	desVar( "lin" <lin> )
	desVar( "win" <win> )
	desVar( "offsetn" 0 )

	option('reltol <reltol> 'gmin <gmin>)
	temp( <temp> )

	monteCarlo( ?startIter <mcStartNum> ?numIters <mcrunNum> ?analysisVariation variationType ?sweptParam "None" ?sweptParamVals "<temp>" ?saveData nil )
	monteExpr( "oval0" "value(v(\"OUT\" ?result 'tran) 1.75*<sao_per>)" )
	monteRun()
)
