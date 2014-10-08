;;;;-----------------------------------
/* This script creates the top-level schematic 
   for an SRAM macro in st65

   By Satyanand Nalam, 03-09-2010
*/

/* Edited by Daniel Reyno, 01-11-2011
   to work with automated generation of
   individual SRAM components. Can generate
   schematics for any technology and assign
   FET sizes read from a parameters file.
*/

;;;;-----------------------------------
;;;; Basic Gates Needed
;;;; 1. inverter
;;;; 2. buffer
;;;; 3. 2-input and
;;;; 4. 2-input nand
;;;; 5. 2-input nor
;;;; 6. tri-state inverter
;;;; 7. D flip-flop
;;;; 8. tx-gate
;;;; 9. 4to1 Mux
;;;;
;;;; Manually need to create the following schematics
;;;;
;;;; Leafcell    		 Name in st65
;;;;
;;;; 1. Bitcell 		 bitcell6T
;;;; 2. WL driver (for 8 WLs)    WLDriver8
;;;; 3. Col-mux			 CD1,2,4,8
;;;; 4. IO Circuits		 IO
;;;; 5. Sense Amp	 	 SA
;;;; 
;;;; For Predecode+Timing block, following schematics are to be
;;;; manually created
;;;; 
;;;; 1. timing block to generate all control signals except decoder related
;;;; 2. Tunable delay composed of delay elements
;;;; 3. Delay element (inv chain)


;; load an initial file that contains procedure required
;; to store minimum FET sizes for technology node
load("./skill/darUvaEceSchematic.il")



;;;;-----------------------------------
;;;; MUST store minimum sizes in association
;;;; table before loading any SKILL file

  ;; read the default FET sizes for the given technology
  minSizeTable = storeData("./skill/minSizes.txt")



;;;;-----------------------------------
;;;; Include procedures for creating component schematics
;;load("./skill/jwBasicSchematic.il")
/*
load("UvaEceBitcellArray_Schem.il")
load("UvaEceBitSlice_Schem.il")
load("UvaEceWLDriver_Schem.il")
load("UvaEceRowPredec_Schem.il")
load("UvaEceColDecoder_Schem.il")
load("UvaEcePredecTiming_Schem.il")
*/
load("./skill/darSchematic.il")
load("./skill/darUvaEceBitSlice_Schem.il")
load("./skill/darUvaEceColDecoder_Schem.il")
load("./skill/darUvaEceRowPredec_Schem.il")
load("./skill/darBitcellArray_Schem.il")
load("./skill/darUvaEceWLDriver_Schem.il")
load("./skill/darTimingBlock_Schem.il")
load("./skill/UvaEcePredecTiming_Schem.il")

;;;;-----------------------------------
;;;; Procedure to create Schematic
procedure(UvaEceCreateSRAMSchematic(libName cellName R C DW n k)

  prog(()

  n = round(cdfParseFloatString(n))
  k = round(cdfParseFloatString(k))

    cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
    UvaEceDeleteObjectsSchematic(cvid)


    ;;; SECTION: SET schematic params
    dx = 5
    dy = 2

    ;;; SECTION: SET UP THE PINS
    x = 0
    y = 0

    ;; INPUT
    ;foreach(pinName list(sprintf(nil "AR<0:%d>" AR-1) sprintf(nil "AC<0:%d>" AC-1) sprintf(nil "DATA_IN<0:%d>" DW-1) "CLK" "WR" )
    foreach(pinName list("AR<0:8>" "AC<0:2>" sprintf(nil "DATA_IN<0:%d>" DW-1) "CLK" "WR" )
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

    ;; INPUT-OUTPUT
    foreach(pinName list("VDD" "VSS" sprintf(nil "DATA_OUT<0:%d>" DW-1))
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

   preWLDriver = darChoosePREWLDriverNode(n)
   pre8_6 = nth(0 preWLDriver)
   pre5_3 = nth(1 preWLDriver)
   pre2_0 = nth(2 preWLDriver)

   preWL = darChoosePREWLNode(k R)

    x=1
    y=0

    ;;;;-----------------------------------
    ;;;; WL Driver

    inst = UvaEceSchematicCreateInst(cvid libName sprintf(nil "WLDRIVER_%d" R) "symbol"
                        "IWLD"
                list(list("WLclk<0:7>" "WLclk<0:7>")
                     list("PRE5_3<0:7>" "PRE5_3<0:7>")
                     list("PRE8_6<0:7>" "PRE8_6<0:7>"))
                list(list(sprintf(nil "WL<0:%d>" R-1) preWL))
                list(list("VSS" "VSS") list("VDD" "VDD"))
		nil
                x:y "R0")

    x=x+dx

    ;;;;-----------------------------------
    ;;;; Bitcell Array

    inst = UvaEceSchematicCreateInst(cvid libName sprintf(nil "6TBITCELL_ARRAY_%dx%d" R C) "symbol"
                        "IBC"
                list(list(sprintf(nil "WL<0:%d>" R-1) sprintf(nil "WL<0:%d>" R-1)))
		nil
                list(list(sprintf(nil "BLB<0:%d>" C-1) sprintf(nil "BLB<0:%d>" C-1))
                     list(sprintf(nil "BL<0:%d>" C-1) sprintf(nil "BL<0:%d>" C-1))
		     list("VSS" "VSS") list("VDD" "VDD"))
		nil
                x:y "R0")

    y=y-dy
    x=x-dx

    ;;;;-----------------------------------
    ;;;; Pre Word Line Driver Buffers

    if(n != 0 then
      inst = UvaEceSchematicCreateInst(cvid libName cellName_PRE_WLBuffer "symbol"
		"I_PRE_WLBuffer"
		list(list("PRE_PRE8_6<0:7>" "PRE_PRE8_6<0:7>")
		     list("PRE_PRE5_3<0:7>" "PRE_PRE5_3<0:7>")
		     list("PRE_WLclk<0:7>" "PRE_WLclk<0:7>"))
		list(list("PRE8_6<0:7>" "PRE8_6<0:7>")
		     list("PRE5_3<0:7>" "PRE5_3<0:7>")
		     list("WLclk<0:7>" "WLclk<0:7>"))
		list(list("VSS" "VSS") list("VDD" "VDD"))
		nil
		x:y "R0")
      x=x+dx
    else
      x=x+dx
    )

    ;;;;-----------------------------------
    ;;;; Word Line Buffers

    if(k != 0 then
      inst = UvaEceSchematicCreateInst(cvid libName sprintf(nil "WLBuffer_%d" R) "symbol"
		"IWLBuffer"
		list(list(sprintf(nil "IN<0:%d>" R-1) sprintf(nil "PRE_WL<0:%d>" R-1)))
		list(list(sprintf(nil "OUT<0:%d>" R-1) sprintf(nil "WL<0:%d>" R-1)))
		list(list("VSS" "VSS") list("VDD" "VDD"))
		nil
		x:y "R0")
      x=x-dx
      y=y-dy
    else
      x=x-dx
      y=y-dy
    )

    ;;;;-----------------------------------
    ;;;; Predecode and Timing

    inst = UvaEceSchematicCreateInst(cvid libName cellName_timingTop "symbol"
                        "ITMNG"
                list(list("AC<0:2>" "AC<0:2>")
                     list("AR<0:8>" "AR<0:8>")
                     list("CLK" "CLK")
                     list("WR" "WR"))
                list(list("CS<0:7>" "CS<0:7>")
                     list("NCS<0:7>" "NCS<0:7>")
                     list("ICLK" "ICLK")
                     list("NPRECH" "NPRECH")
                     list("NSAPREC" "NSAPREC")
                     list("SAE" "SAE")
                     list("WEN" "WEN")
                     list("PRE8_6<0:7>" pre8_6)
                     list("PRE5_3<0:7>" pre5_3)
                     list("WLclk<0:7>" pre2_0))
                list(list("VDD" "VDD")
                     list("VSS" "VSS"))
                nil
                x:y "R0")

    x=x+dx

    ;;;;-----------------------------------
    ;;;; Bitslice - special case for no col mux
    if(DW != 1 then
      inst = UvaEceSchematicCreateInst(cvid libName sprintf(nil "BITSLICE_%d" C) "symbol"
                        "IBSLC"
                list(list("CSEL<0:7>" "CS<0:7>")
                     list("CSELB<0:7>" "NCS<0:7>")
                     list(sprintf(nil "DIN<0:%d>" DW-1) sprintf(nil "DATA_IN<0:%d>" DW-1))
                     list("ICLK" "ICLK")
                     list("OCLK" "ICLK")
                     list("PCH" "NPRECH")
                     list("SAE" "SAE")
                     list("SAPREC" "NSAPREC")
                     list("WEN" "WEN"))
                list(list(sprintf(nil "DOUT<0:%d>" DW-1) sprintf(nil "DATA_OUT<0:%d>" DW-1)))
                list(list("VDD" "VDD")
                     list("VSS" "VSS")
                     list(sprintf(nil "BLB<0:%d>" C-1) sprintf(nil "BLB<0:%d>" C-1))
                     list(sprintf(nil "BL<0:%d>" C-1) sprintf(nil "BL<0:%d>" C-1)))
                nil  
                x:y "R0")
    else
       inst = UvaEceSchematicCreateInst(cvid libName sprintf(nil "BITSLICE_%d" C) "symbol"
                        "IBSLC"
                list(list("CSEL<0:7>" "CS<0:7>")
                     list("CSELB<0:7>" "NCS<0:7>")
                     list("DIN<0>" "DATA_IN<0>")
                     list("ICLK" "ICLK")
                     list("OCLK" "ICLK")
                     list("PCH" "NPRECH")
                     list("SAE" "SAE")
                     list("SAPREC" "NSAPREC")
                     list("WEN" "WEN"))
                list(list("DOUT<0>" "DATA_OUT<0>"))
                list(list("VDD" "VDD")
                     list("VSS" "VSS")
                     list(sprintf(nil "BLB<0:%d>" C-1) sprintf(nil "BLB<0:%d>" C-1))
                     list(sprintf(nil "BL<0:%d>" C-1) sprintf(nil "BL<0:%d>" C-1)))
                nil  
                x:y "R0")
    )

    dbSave(cvid)
    dbClose(cvid)

    printf("=== Cell %L schematic has been created! ===\n", cellName)

    jwCheckSchematic(libName cellName)

  ) ;end prog

) ;end CreateSRAMSchematic


;;;;-----------------------------------
;;;; Main Entry
;;;;
let((libName cellName R C DW );;MUX)

  ;; read the parameters file and store the values in an association table
  sizes=storeData(minSizeTable["sizesPath"])

  ;; read the specs file and store the values in an association table
  inputs=storeData(minSizeTable["inputsPath"])

  ;; library name for all the cells
  libName = inputs["libName"]

  ;; letter case required for given technology
  technologyCase = inputs["technologyCase"]

  ;; library name of FET location
  FETlibName = inputs["FETlibName"]

  ;; cell name for PMOS device
  PMOScellName = inputs["PMOScellName"]

  ;; cell name for NMOS device
  NMOScellName = inputs["NMOScellName"]

  ;Arch specs
  R = inputs["rows"]
  addrBits = inputs["addrBits"]
  C = inputs["columns"]
  DW = inputs["wordSize"]
  ;;MUX = C/DW

  R = round(cdfParseFloatString(R))
  addrBits = round(cdfParseFloatString(addrBits))
  C = round(cdfParseFloatString(C))
  DW = round(cdfParseFloatString(DW))

  ;;;; Component cellnames
  sprintf(cellName_bcArray "6TBITCELL_ARRAY_%dx%d" R C)
  sprintf(cellName_WLDriver "WLDRIVER_%d" R)
  sprintf(cellName_bitSlice "BITSLICE_%d" C)

  cellName_predec = "preDecode"
  cellName_coldec = "colDecoder"
  cellName_timing = "timingBlock"
  cellName_timingTop = "TIMING_PREDEC"
  cellName_bcArray = sprintf(nil "6TBITCELL_ARRAY_%dx%d" R C)
  cellName_WLDriver = sprintf(nil "WLDRIVER_%d" R)
  cellName_SA = "SenseAmp"
  cellName_IO = "IOBlock"
  cellName_CD = "CD"

  cellName_inverter = "inverter"
  cellName_buffer = "buffer"
  cellName_nand = "NAND2"
  cellName_and = "AND2"
  cellName_nor = "NOR2"
  cellName_triState = "TriStateInverter"
  cellName_bitcell = "bitcell"
  cellName_DFF = "DFF"
  cellName_WLDriver8 = "WLDriver8"
  cellName_WLBuffer = sprintf(nil "WLBuffer_%d" R)
  cellName_PRE_WLBuffer = sprintf(nil "PRE_WLBuffer_%d" R)

  ;; cell names and number of stages for the timing block buffer chains
  ;; all data is read from the parameters file
  cellName_dlyWLbuffChain = "DLY_WL_BChain"
  dlyWLstages = sizes["dlyWLstages"]
  dlyWLFanOut = sizes["dlyWLFanOut"]

  cellName_ICLKbuffChain = "ICLK_BChain"
  ICLKstages = sizes["ICLKstages"]
  ICLKFanOut = sizes["ICLKFanOut"]
  cellName_NSAPRECbuffChain = "NSAPREC_BChain"
  NSAPRECstages = sizes["NSAPRECstages"]
  NSAPRECFanOut = sizes["NSAPRECFanOut"]
  cellName_WLENbuffChain = "WLEN_BChain"
  WLENstages = sizes["WLENstages"]
  WLENFanOut = sizes["WLENFanOut"]
  cellName_SAEbuffChain = "SAE_BChain"
  SAEstages = sizes["SAEstages"]
  SAEFanOut = sizes["SAEFanOut"]
  cellName_WENbuffChain = "WEN_BChain"
  WENstages = sizes["WENstages"]
  WENFanOut = sizes["WENFanOut"]
  cellName_NPRECHbuffChain = "NPRECH_BChain"
  NPRECHstages = sizes["NPRECHstages"]
  NPRECHFanOut = sizes["NPRECHFanOut"]

  ;; cell name and number of stages for the CSEL buffer chain in top level timing
  cellName_CSELBuffChain = "CSEL_BChain"
  CSELstages = sizes["CSELstages"]
  CSELFanOut = sizes["CSELFanOut"]

  ;;;; Create the component schematics, symbols, check-save

  ;; basic components
  darCreateInverterSchematic(libName cellName_inverter FETlibName PMOScellName NMOScellName technologyCase)

  darCreateBufferSchematic(libName cellName_buffer FETlibName PMOScellName NMOScellName technologyCase)

  darCreateNAND2Schematic(libName cellName_nand FETlibName PMOScellName NMOScellName technologyCase)

  darCreateAND2Schematic(libName cellName_and FETlibName PMOScellName NMOScellName technologyCase)

  darCreateNOR2Schematic(libName cellName_nor FETlibName PMOScellName NMOScellName technologyCase)

  darCreateTriStateInverterSchematic(libName cellName_triState FETlibName PMOScellName NMOScellName technologyCase)

  darCreateBitcellSchematic(libName cellName_bitcell FETlibName PMOScellName NMOScellName technologyCase ?wpu sizes["wpu"] ?wpg sizes["wpg"] ?wpd sizes["wpd"] ?lpu sizes["lpu"] ?lpg sizes["lpg"] ?lpd sizes["lpd"])

  darCreateDFFSchematic(libName cellName_DFF FETlibName PMOScellName NMOScellName technologyCase)

  ;; Buffer Chain for DLY_WLEN in timing block
  darCreateBufferChainSchematic(libName cellName_dlyWLbuffChain FETlibName PMOScellName NMOScellName technologyCase dlyWLstages dlyWLFanOut)
  ;; Buffer Chain for IcLK in timing block
  darCreateBufferChainSchematic(libName cellName_ICLKbuffChain FETlibName PMOScellName NMOScellName technologyCase ICLKstages ICLKFanOut)
  ;; Buffer Chain for NSAPREC in timing block
  darCreateBufferChainSchematic(libName cellName_NSAPRECbuffChain FETlibName PMOScellName NMOScellName technologyCase NSAPRECstages NSAPRECFanOut)
  ;; Buffer Chain for WLEN in timing block
  darCreateBufferChainSchematic(libName cellName_WLENbuffChain FETlibName PMOScellName NMOScellName technologyCase WLENstages WLENFanOut)
  ;; Buffer Chain for SAE in timing block
  darCreateBufferChainSchematic(libName cellName_SAEbuffChain FETlibName PMOScellName NMOScellName technologyCase SAEstages SAEFanOut)
  ;; Buffer Chain for WEN in timing block
  darCreateBufferChainSchematic(libName cellName_WENbuffChain FETlibName PMOScellName NMOScellName technologyCase WENstages WENFanOut)
  ;; Buffer Chain for NPRECH in timing block
  darCreateBufferChainSchematic(libName cellName_NPRECHbuffChain FETlibName PMOScellName NMOScellName technologyCase NPRECHstages NPRECHFanOut)

  ;; Buffer Chain for the CSEL signal in top level timing
  darCreateBufferChainSchematic(libName cellName_CSELBuffChain FETlibName PMOScellName NMOScellName technologyCase CSELstages CSELFanOut)

  ;; bitcell array
  darCreateArraySchematic(libName cellName_bcArray R C cellName_bitcell)
  ;;jwCreateSymbolFromSchematic(libName cellName_bcArray)
  ;;jwCheckSchematic(libName cellName_bcArray)

  ;; WL driver
  darCreateWLDriver8Schematic(libName cellName_WLDriver8 cellName_inverter cellName_nand cellName_and)
  darUvaEceCreateWLDriverSchematic(libName cellName_WLDriver R cellName_WLDriver8)
  ;;jwCreateSymbolFromSchematic(libName cellName_WLDriver)
  ;;jwCheckSchematic(libName cellName_WLDriver)

  ;; bitslice
  ;; *Edited by DAR. Added automatic generation of
  ;; Sense Amp, I/O circuit, and CD.

  ;; Create SenseAmp, I/O Circuit, and CD to pass to BitSlice procedure
  darCreateSenseAmpSchematic(libName cellName_SA FETlibName PMOScellName NMOScellName technologyCase cellName_nand ?wen sizes["SAwen"] ?len sizes["SAlen"] ?weql sizes["SAweql"] ?leql sizes["SAleql"] ?wpsa sizes["SAwpsa"] ?lpsa sizes["SAlpsa"] ?wnsa sizes["SAwnsa"] ?lnsa sizes["SAlnsa"] ?wbl sizes["SAwbl"] ?lbl sizes["SAlbl"] ?wsapc sizes["SAwsapc"] ?lsapc sizes["SAlsapc"] ?wpNAND sizes["SAwpNAND"] ?lpNAND sizes["SAlpNAND"] ?wnNAND sizes["SAwnNAND"] ?lnNAND sizes["SAlnNAND"])

  darCreateIOSchematic(libName cellName_IO cellName_inverter cellName_triState cellName_DFF ?TSIwpINV sizes["TSIwpINV"] ?TSIwnINV sizes["TSIwnINV"] ?TSIwpEN sizes["TSIwpEN"] ?TSIwnEN sizes["TSIwnEN"] ?TSIlpINV sizes["TSIlpINV"] ?TSIlnINV sizes["TSIlnINV"] ?TSIlpEN sizes["TSIlpEN"] ?TSIlnEN sizes["TSIlnEN"] ?IOwpINV sizes["IOwpINV"] ?IOwnINV sizes["IOwnINV"] ?IOlpINV sizes["IOlpINV"] ?IOlnINV sizes["IOlnINV"])

  darChooseAndCreateCDSchematic(libName cellName_CD FETlibName PMOScellName NMOScellName technologyCase C DW ?wpc sizes["CDwpc"] ?lpc sizes["CDlpc"] ?wpTX sizes["CDwpTX"] ?lpTX  sizes["CDlpTX"] ?wnTX sizes["CDwnTX"] ?lnTX sizes["CDlnTX"])

  darUvaEceCreateBitSliceSchematic(libName cellName_bitSlice cellName_SA cellName_IO cellName_CD C DW)
  ;;jwCreateSymbolFromSchematic(libName cellName_bitSlice)
  ;;jwCheckSchematic(libName cellName_bitSlice)

  ;; predecode and timing
  ; predecode
  darUvaEceCreatePredecSchematic(libName cellName_predec addrBits cellName_inverter cellName_and)
  ;jwCreateSymbolFromSchematic(libName cellName_predec)
  ;jwCheckSchematic(libName cellName_predec)

  ; column decoder
  darUvaEceCreateColDecSchematic(libName cellName_coldec cellName_inverter cellName_and)
  ;;jwCreateSymbolFromSchematic(libName cellName_coldec)
  ;;jwCheckSchematic(libName cellName_coldec)

  ; timing block
  darCreateTimingBlockSchematic(libName cellName_timing cellName_inverter cellName_buffer cellName_nand cellName_and cellName_nor cellName_dlyWLbuffChain cellName_ICLKbuffChain cellName_NSAPRECbuffChain cellName_WLENbuffChain cellName_SAEbuffChain cellName_WENbuffChain cellName_NPRECHbuffChain)

  ; timing top-level
  UvaEceCreateTimingSchematic(libName cellName_timingTop cellName_predec cellName_coldec cellName_timing cellName_buffer cellName_nand cellName_DFF cellName_CSELBuffChain)
  ;;jwCreateSymbolFromSchematic(libName cellName_timingTop)
  ;;jwCheckSchematic(libName cellName_timingTop)


  ;; Create n, k buffer chains
  Nstages=sizes["Nstages"]
  NFanOut=sizes["NFanOut"]
  cellName_PRE_WLBufferChain="Nchain"
  darCreateBufferChainSchematic(libName cellName_PRE_WLBufferChain FETlibName PMOScellName NMOScellName technologyCase Nstages NFanOut)

  darCreatePREWLBufferSchematic(libName cellName_PRE_WLBuffer cellName_PRE_WLBufferChain)

  Kstages=sizes["Kstages"]
  KFanOut=sizes["KFanOut"]
  cellName_WLBufferChain="Kchain"
  darCreateBufferChainSchematic(libName cellName_WLBufferChain FETlibName PMOScellName NMOScellName technologyCase Kstages KFanOut)

  darCreateWLBufferSchematic(libName cellName_WLBuffer R cellName_WLBufferChain)


  ;; Create top-level macro
  sprintf(cellName "SRAM_%dx%d_%d" R C DW)
  UvaEceCreateSRAMSchematic(libName cellName R C DW Nstages Kstages)
  ;jwCreateSymbolFromSchematic(libName cellName)
  ;jwCheckSchematic(libName cellName)


)
