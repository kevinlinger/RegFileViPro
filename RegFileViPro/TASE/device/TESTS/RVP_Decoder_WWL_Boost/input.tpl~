;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; OCEAN script to test power and delay of
;; ViPro Decoder
;; Domenic Carr 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; SET SIMULATOR
simulator( 'spectre )

; reduce the loops to a single iteration if only getting metrics for a particular configuration
numWords = <memsize>/<ws>

aList = '(<addrRow>)


foreach(a aList

	;; COPY AND SET NETLIST
	cpnetlist = sprintf(nil "cp -f ./%Lbits/netlist ." a)
    	sh( cpnetlist )
    	design( "./netlist" )

	modelFile(
	    '("<include>")
	    '("<subN>")
	    '("<subP>")
	    '("<subPU>")
	    '("<subPD>")
	    '("<subPG>")
	)

	;; SET parameters as needed
	desVar( "wdef" <wdef> )
	desVar( "ldef" <ldef> )
	desVar( "wpu" <wpu>   )
	desVar( "lpu" <lpu>   )
	desVar( "wpd" <wpd>   )
	desVar( "lpd" <lpd>   )
	desVar( "wpg" <wpg>   )
	desVar( "lpg" <lpg>   )
	desVar(	"cwl" <cwl>   )
	desVar("cg" <cg>)
	desVar( "pvdd" <pvdd> )

	pvdd = <pvdd>
	capacity = <memsize>
	size_word = <ws>
	height_memory = <NR_sweep>
	

	;; SET TEMPERATURE
	temp( <temp> )

	;; SET RESULT DIRECTORY
	sprintf(dir "./TranResults")
	resultsDir( dir )

	;; CONSTANTS
	permicron = 1/1000n 		; used to convert parasitic values to per micron values

	;; GLOBAL VARIABLES
	max_capacity = pow(2 17)	;max size of memory - initially set to 2^17, will be set by code
	min_capacity = 	8		;min capacity initialized to 8, but will be determined later on in code

	;;READ FILE TO DETERMINE NUMBER OF ROW ADDRESS BITS
	inrow = infile(sprintf(nil "./%Lbits/bitspec" a))	;numrowbits is a text file specific to each *bits directory
	fscanf( inrow "%d\n%d\n%d\n%d\n%d\n%d" r predecoderEnergyMult nBufferEnergyMult fanoutEnergyMult fanoutinvEnergyMult wldEnergyMult)
	close( inrow )

	;;START OF CALCULATIONS

	;; DEFINE OUTPUT PRINT FILE
	of = outfile( sprintf(nil "output_%L.txt" a) "w" )
	
				rows = <NR_sweep>
				numberOfBitcellsPerRow = <NC_sweep>
				desVar( "multiplier" numberOfBitcellsPerRow )
				desVar( "wireRes" rows*<rbl> )
				desVar( "wireCap" rows*<cbl>)
				wireCap = rows*<cbl>

				;;RUN ANALYSIS
				analysis( 'tran ?start 0 ?stop 32n ?step 0.01n ?strobeperiod 0.01n ?errpreset 'conservative )
				save( 'all )
				run()           

				;; PLOT THE SIGNALS
				selectResults('tran)

				;; MEASURE and PRINT the propagation delay of the decoder 

				bufn = 0
				bufk = 0

				tplh = delay( v("in0") pvdd/2.0 1 'rising v("WL0") pvdd/2.0 1 'rising )
				invPwr = r*average(getData("DUT0.Inv0:pwr"))
				predecoderPwr = predecoderEnergyMult*average(getData("DUT0.Predecoder0:pwr"))
				nbufferPwr = nBufferEnergyMult*average(getData("DUT0.Nbuffer0:pwr"))
				parPwr = nBufferEnergyMult*average(getData("DUT0.PAR0:pwr"))
				nandPwr=0
				inv2Pwr=0
				if( (r != 3)
				    then
					nandPwr = fanoutEnergyMult*average(getData("DUT0.Nand2:pwr"))
					inv2Pwr = fanoutinvEnergyMult*average(getData("DUT0.Inv2:pwr"))
				  )
				wldriverPwr = wldEnergyMult*average(getData("DUT0.WLdriver0:pwr"))
				kbufferPwr = wldEnergyMult*average(getData("DUT0.Kbuffer0:pwr"))
				avgPwr = invPwr + predecoderPwr + nbufferPwr + parPwr + nandPwr + inv2Pwr + wldriverPwr + kbufferPwr

				fprintf( of "%d\t%d\t%d\t%e\t%e\t%e\t%d\n", rows, bufn, bufk, tplh, avgPwr, wireCap, numberOfBitcellsPerRow)

				
	
	close( of )
)
