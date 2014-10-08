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
	desVar( "wrd1" <wrd1> )
	desVar( "lrd1" <lrd1> )
	desVar( "wrdpg" <wrdpg>   )
	desVar( "lrdpg" <lrdpg>   )
	desVar( "wpd" <wpd>   )
	desVar( "lpd" <lpd>   )
	desVar( "wpg" <wpg>   )
	desVar( "lpg" <lpg>   )
	desVar(	"cwl" <cwl>   )
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
				numberOfBitcellsPerRow = <NC_sweep>/2
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

				tplh = delay( v("in0") pvdd/2.0 1 'falling v("WL0") pvdd/2.0 1 'rising )
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

				bufn = bufn + 1
				tplh = delay( v("in1") pvdd/2.0 1 'falling v("WL1") pvdd/2.0 1 'rising )
				invPwr = r*average(getData("DUT1.Inv0:pwr"))
				predecoderPwr = predecoderEnergyMult*average(getData("DUT1.Predecoder0:pwr"))
				nbufferPwr = nBufferEnergyMult*average(getData("DUT1.Nbuffer0:pwr"))
				parPwr = nBufferEnergyMult*average(getData("DUT1.PAR0:pwr"))
				nandPwr=0
				inv2Pwr=0
				if( (r != 3)
				    then
					nandPwr = fanoutEnergyMult*average(getData("DUT1.Nand2:pwr"))
					inv2Pwr = fanoutinvEnergyMult*average(getData("DUT1.Inv2:pwr"))
				  )
				wldriverPwr = wldEnergyMult*average(getData("DUT1.WLdriver0:pwr"))
				kbufferPwr = wldEnergyMult*average(getData("DUT1.Kbuffer0:pwr"))
				avgPwr = invPwr + predecoderPwr + nbufferPwr + parPwr + nandPwr + inv2Pwr + wldriverPwr + kbufferPwr

				fprintf( of "%d\t%d\t%d\t%e\t%e\t%e\t%d\n", rows, bufn, bufk, tplh, avgPwr, wireCap, numberOfBitcellsPerRow)

				bufn = bufn + 1
				tplh = delay( v("in2") pvdd/2.0 1 'falling v("WL2") pvdd/2.0 1 'rising )
				invPwr = r*average(getData("DUT2.Inv0:pwr"))
				predecoderPwr = predecoderEnergyMult*average(getData("DUT2.Predecoder0:pwr"))
				nbufferPwr = nBufferEnergyMult*average(getData("DUT2.Nbuffer0:pwr"))
				parPwr = nBufferEnergyMult*average(getData("DUT2.PAR0:pwr"))
				nandPwr=0
				inv2Pwr=0
				if( (r != 3)
				    then
					nandPwr = fanoutEnergyMult*average(getData("DUT2.Nand2:pwr"))
					inv2Pwr = fanoutinvEnergyMult*average(getData("DUT2.Inv2:pwr"))
				  )
				wldriverPwr = wldEnergyMult*average(getData("DUT2.WLdriver0:pwr"))
				kbufferPwr = wldEnergyMult*average(getData("DUT2.Kbuffer0:pwr"))
				avgPwr = invPwr + predecoderPwr + nbufferPwr + parPwr + nandPwr + inv2Pwr + wldriverPwr + kbufferPwr

				fprintf( of "%d\t%d\t%d\t%e\t%e\t%e\t%d\n", rows, bufn, bufk, tplh, avgPwr, wireCap, numberOfBitcellsPerRow)

				bufn = bufn - 2
				bufk = bufk + 1
				tplh = delay( v("in3") pvdd/2.0 1 'falling v("WL3") pvdd/2.0 1 'rising )
				invPwr = r*average(getData("DUT3.Inv0:pwr"))
				predecoderPwr = predecoderEnergyMult*average(getData("DUT3.Predecoder0:pwr"))
				nbufferPwr = nBufferEnergyMult*average(getData("DUT3.Nbuffer0:pwr"))
				parPwr = nBufferEnergyMult*average(getData("DUT3.PAR0:pwr"))
				nandPwr=0
				inv2Pwr=0
				if( (r != 3)
				    then
					nandPwr = fanoutEnergyMult*average(getData("DUT3.Nand2:pwr"))
					inv2Pwr = fanoutinvEnergyMult*average(getData("DUT3.Inv2:pwr"))
				  )
				wldriverPwr = wldEnergyMult*average(getData("DUT3.WLdriver0:pwr"))
				kbufferPwr = wldEnergyMult*average(getData("DUT3.Kbuffer0:pwr"))
				avgPwr = invPwr + predecoderPwr + nbufferPwr + parPwr + nandPwr + inv2Pwr + wldriverPwr + kbufferPwr

				fprintf( of "%d\t%d\t%d\t%e\t%e\t%e\t%d\n", rows, bufn, bufk, tplh, avgPwr, wireCap, numberOfBitcellsPerRow)

				bufn = bufn + 1
				tplh = delay( v("in4") pvdd/2.0 1 'falling v("WL4") pvdd/2.0 1 'rising )
				invPwr = r*average(getData("DUT4.Inv0:pwr"))
				predecoderPwr = predecoderEnergyMult*average(getData("DUT4.Predecoder0:pwr"))
				nbufferPwr = nBufferEnergyMult*average(getData("DUT4.Nbuffer0:pwr"))
				parPwr = nBufferEnergyMult*average(getData("DUT4.PAR0:pwr"))
				nandPwr=0
				inv2Pwr=0
				if( (r != 3)
				    then
					nandPwr = fanoutEnergyMult*average(getData("DUT4.Nand2:pwr"))
					inv2Pwr = fanoutinvEnergyMult*average(getData("DUT4.Inv2:pwr"))
				  )
				wldriverPwr = wldEnergyMult*average(getData("DUT4.WLdriver0:pwr"))
				kbufferPwr = wldEnergyMult*average(getData("DUT4.Kbuffer0:pwr"))
				avgPwr = invPwr + predecoderPwr + nbufferPwr + parPwr + nandPwr + inv2Pwr + wldriverPwr + kbufferPwr

				fprintf( of "%d\t%d\t%d\t%e\t%e\t%e\t%d\n", rows, bufn, bufk, tplh, avgPwr, wireCap, numberOfBitcellsPerRow)

				bufn = bufn + 1
				tplh = delay( v("in5") pvdd/2.0 1 'falling v("WL5") pvdd/2.0 1 'rising )
				invPwr = r*average(getData("DUT5.Inv0:pwr"))
				predecoderPwr = predecoderEnergyMult*average(getData("DUT5.Predecoder0:pwr"))
				nbufferPwr = nBufferEnergyMult*average(getData("DUT5.Nbuffer0:pwr"))
				parPwr = nBufferEnergyMult*average(getData("DUT5.PAR0:pwr"))
				nandPwr=0
				inv2Pwr=0
				if( (r != 3)
				    then
					nandPwr = fanoutEnergyMult*average(getData("DUT5.Nand2:pwr"))
					inv2Pwr = fanoutinvEnergyMult*average(getData("DUT5.Inv2:pwr"))
				  )
				wldriverPwr = wldEnergyMult*average(getData("DUT5.WLdriver0:pwr"))
				kbufferPwr = wldEnergyMult*average(getData("DUT5.Kbuffer0:pwr"))
				avgPwr = invPwr + predecoderPwr + nbufferPwr + parPwr + nandPwr + inv2Pwr + wldriverPwr + kbufferPwr

				fprintf( of "%d\t%d\t%d\t%e\t%e\t%e\t%d\n", rows, bufn, bufk, tplh, avgPwr, wireCap, numberOfBitcellsPerRow)

				bufn = bufn - 2
				bufk = bufk + 1
				tplh = delay( v("in6") pvdd/2.0 1 'falling v("WL6") pvdd/2.0 1 'rising )
				invPwr = r*average(getData("DUT6.Inv0:pwr"))
				predecoderPwr = predecoderEnergyMult*average(getData("DUT6.Predecoder0:pwr"))
				nbufferPwr = nBufferEnergyMult*average(getData("DUT6.Nbuffer0:pwr"))
				parPwr = nBufferEnergyMult*average(getData("DUT6.PAR0:pwr"))
				nandPwr=0
				inv2Pwr=0
				if( (r != 3)
				    then
					nandPwr = fanoutEnergyMult*average(getData("DUT6.Nand2:pwr"))
					inv2Pwr = fanoutinvEnergyMult*average(getData("DUT6.Inv2:pwr"))
				  )
				wldriverPwr = wldEnergyMult*average(getData("DUT6.WLdriver0:pwr"))
				kbufferPwr = wldEnergyMult*average(getData("DUT6.Kbuffer0:pwr"))
				avgPwr = invPwr + predecoderPwr + nbufferPwr + parPwr + nandPwr + inv2Pwr + wldriverPwr + kbufferPwr

				fprintf( of "%d\t%d\t%d\t%e\t%e\t%e\t%d\n", rows, bufn, bufk, tplh, avgPwr, wireCap, numberOfBitcellsPerRow)

				bufn = bufn + 1
				tplh = delay( v("in7") pvdd/2.0 1 'falling v("WL7") pvdd/2.0 1 'rising )
				invPwr = r*average(getData("DUT7.Inv0:pwr"))
				predecoderPwr = predecoderEnergyMult*average(getData("DUT7.Predecoder0:pwr"))
				nbufferPwr = nBufferEnergyMult*average(getData("DUT7.Nbuffer0:pwr"))
				parPwr = nBufferEnergyMult*average(getData("DUT7.PAR0:pwr"))
				nandPwr=0
				inv2Pwr=0
				if( (r != 3)
				    then
					nandPwr = fanoutEnergyMult*average(getData("DUT7.Nand2:pwr"))
					inv2Pwr = fanoutinvEnergyMult*average(getData("DUT7.Inv2:pwr"))
				  )
				wldriverPwr = wldEnergyMult*average(getData("DUT7.WLdriver0:pwr"))
				kbufferPwr = wldEnergyMult*average(getData("DUT7.Kbuffer0:pwr"))
				avgPwr = invPwr + predecoderPwr + nbufferPwr + parPwr + nandPwr + inv2Pwr + wldriverPwr + kbufferPwr

				fprintf( of "%d\t%d\t%d\t%e\t%e\t%e\t%d\n", rows, bufn, bufk, tplh, avgPwr, wireCap, numberOfBitcellsPerRow)

				bufn = bufn + 1
				tplh = delay( v("in8") pvdd/2.0 1 'falling v("WL8") pvdd/2.0 1 'rising )
				invPwr = r*average(getData("DUT8.Inv0:pwr"))
				predecoderPwr = predecoderEnergyMult*average(getData("DUT8.Predecoder0:pwr"))
				nbufferPwr = nBufferEnergyMult*average(getData("DUT8.Nbuffer0:pwr"))
				parPwr = nBufferEnergyMult*average(getData("DUT8.PAR0:pwr"))
				nandPwr=0
				inv2Pwr=0
				if( (r != 3)
				    then
					nandPwr = fanoutEnergyMult*average(getData("DUT8.Nand2:pwr"))
					inv2Pwr = fanoutinvEnergyMult*average(getData("DUT8.Inv2:pwr"))
				  )
				wldriverPwr = wldEnergyMult*average(getData("DUT8.WLdriver0:pwr"))
				kbufferPwr = wldEnergyMult*average(getData("DUT8.Kbuffer0:pwr"))
				avgPwr = invPwr + predecoderPwr + nbufferPwr + parPwr + nandPwr + inv2Pwr + wldriverPwr + kbufferPwr

				fprintf( of "%d\t%d\t%d\t%e\t%e\t%e\t%d\n", rows, bufn, bufk, tplh, avgPwr, wireCap, numberOfBitcellsPerRow)
	
	close( of )
)
