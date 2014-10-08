;;;;-----------------------------------
/* This script creates the top-level predecode
   and timing block for the SRAM macro 
   R=rows C=cols DW=word-size col-mux=C/DW
   AR=row-addr bits
   AC=col-addr bits
   By Satyanand Nalam, 03-09-2010
*/

;load("jwBasicSchematic.il")

;;;;-----------------------------------
;;;; Procedure to create Schematic
;;;; C=cols DW=word-size
;;;;-----------------------------------

procedure(UvaEceCreateTimingSchematic(libName cellName cellName_preDec cellName_colDec cellName_timing cellName_buffer cellName_nand cellName_DFF cellName_bufferChain)

  prog(()

    cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
    UvaEceDeleteObjectsSchematic(cvid)


    ;;; SECTION: SET schematic params
    dx = 4
    dy = 3

    ;;; SECTION: SET UP THE PINS
    x = 0
    y = 0

    ;; INPUT-OUTPUT
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

    ;; OUTPUT
    foreach(pinName list("CS<0:7>" "NCS<0:7>" "WLclk<0:7>" "PRE8_6<0:7>" "PRE5_3<0:7>" "ICLK" "NPRECH" "NSAPREC" "SAE" "WEN")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

    ;; INPUT
    foreach(pinName list("WR" "CLK" "AR<0:8>" "AC<0:2>")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

    x=2
    y=0

    ;;;;-----------------------------------
    ;;;; Input Flops
    foreach(pinName list("WR" "AR<0:8>" "AC<0:2>")
	inst = UvaEceSchematicCreateInst(cvid libName cellName_DFF "symbol"
		sprintf(nil "I%s" pinName)
		list(list("CLK" "CLK")
		     list("D" sprintf(nil "%s" pinName)))
		list(list("Q" sprintf(nil "CKD_%s" pinName)))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
                x:y "R0")
	y=y-dy
   )
  
   y=0
   x=x+dx
    
   ;;;;-----------------------------------
   ;;;; Predecode

    inst = UvaEceSchematicCreateInst(cvid libName cellName_preDec "symbol"
	          "IPD"
	      list(list("A<0:8>" "CKD_AR<0:8>")
		   list("WLEN" "WLEN"))
	      nil
	      list(list("VSS" "VSS")
                   list("VDD" "VDD")
		   list("WLclk<0:7>" "WLclk<0:7>")
		   list("PRE8_6<0:7>" "PRE8_6<0:7>")
		   list("PRE5_3<0:7>" "PRE5_3<0:7>"))
	      nil
	      x:y "R0")
    x=x+dx

    ;;;;-----------------------------------
    ;;;; Col decode

    inst = UvaEceSchematicCreateInst(cvid libName cellName_colDec "symbol"
                  "IColDec"
              list(list("in<0:2>" "CKD_AC<0:2>"))
	      list(list("out<0:7>" "DEC_AC<0:7>"))
              list(list("VSS" "VSS")
		   list("VDD" "VDD"))
	      nil
              x:y "R0")
    x=x+dx

    ;;;;-----------------------------------
    ;;;; Timing

    inst = UvaEceSchematicCreateInst(cvid libName cellName_timing "symbol"
              "ITMG"
              list(list("CLK" "CLK")
		   list("WR" "CKD_WR"))
	      list(list("CSEL" "CSEL")
		   list("ICLK" "ICLK")
		   list("NPRECH" "NPRECH")
		   list("NSAPREC" "NSAPREC")
		   list("SAE" "SAE")
		   list("WEN" "WEN")
		   list("WLEN" "WLEN"))
	      list(list("VDD" "VDD")
	           list("VSS" "VSS"))
	      nil
              x:y "R0")
    ;;x=x-dx
    y=y-dy
   
    ;;;;-----------------------------------
    ;;;; Buffered Final col-mux select signals
   inst = UvaEceSchematicCreateInst(cvid libName cellName_bufferChain "symbol" "IBCS<0:7>"
   		list(list("IN" "PRE_CS<0:7>"))
   		list(list("OUT" "CS<0:7>"))
   		list(list("VDD" "VDD") list("VSS"))
   		nil
   		x:y "R0")

   y=y-dy
   inst = UvaEceSchematicCreateInst(cvid libName cellName_bufferChain "symbol" "IBCSB<0:7>"
   		list(list("IN" "PRE_NCS<0:7>"))
   		list(list("OUT" "NCS<0:7>"))
   		list(list("VDD" "VDD") list("VSS"))
   		nil
   		x:y "R0")

    ;;;;-----------------------------------
    ;;;; Final col-mux select signals

    x=x-dx
   inst = darUvaEceSchematicCreateInstParNand2(cvid libName cellName_nand "INANDCSB<0:7>"
		"CSEL"
		"DEC_ACB<0:7>"
		"PRE_NCS<0:7>"
		"VDD"
		"VSS"
		x:y)

    y=y+dy
    inst = darUvaEceSchematicCreateInstParAnd2(cvid libName cellName_and "IANDCS<0:7>"
		"CSEL"
		"DEC_AC<0:7>"
		"PRE_CS<0:7>"
		"VDD"
		"VSS"
		x:y)

   y=y-dy
   x=x-dx
   inst = darUvaEceSchematicCreateInstParBuf(cvid libName cellName_buffer "IBUFCSB2<0:7>"
   		"DEC_AC<0:7>"
   		"DEC_ACB<0:7>"
   		"VDD"
   		"VSS"
   		x:y)

   dbSave(cvid)
   dbClose(cvid)

   jwCreateSymbolFromSchematic(libName cellName)
   jwCheckSchematic(libName cellName)

  ) ;end prog

) ;end CreateTimingSchematic

/*
;;;;-----------------------------------
;;;; Main Entry
;;;;
let((libName cellName C DW )

  libName="testLib"
  cellName="darPredecTiming"
  cellName_preDec="dar_Predec_test"
  cellName_colDec="colDecoder"
  cellName_timing="TimingDAR"
  cellName_buffer = "BUFFER"
  cellName_nand = "NAND2"
  cellName_DFF = "DFF"
  cellName_bufferChain = "BChain"

  ;Architectural specs
  ;AR
  ;AC
  ;C = 8
  ;DW = 2

  ;; Create Predecode and Timing
  UvaEceCreateTimingSchematic(libName cellName cellName_preDec cellName_colDec cellName_timing cellName_buffer cellName_nand cellName_DFF cellName_bufferChain)
  jwCreateSymbolFromSchematic(libName cellName)
  ;jwCheckSchematic(libName cellName)
)
*/