;;;;-----------------------------------
/* This script creates the schematic for the
   Timing Block

   By Daniel Reyno, 01-07-2011
*/

;;load("jwBasicSchematic.il")
load("./skill/darSchematic.il")

;;;;-----------------------------------
;;;; Procedure to create Schematic
;;;;-----------------------------------

procedure( darCreateTimingBlockSchematic(libName cellName cellName_inverter cellName_buffer cellName_nand cellName_and cellName_nor cellName_dlyWLbuffChain cellName_ICLKbuffChain cellName_NSAPRECbuffChain cellName_WLENbuffChain cellName_SAEbuffChain cellName_WENbuffChain cellName_NPRECHbuffChain @key (wp 180.0n) (wn 90.0n) (lp 50.0n) (ln 50.0n))

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 4
  dy = 1.5

  ;;; SECTION: SET UP THE PINS
  x = 0.5
  y = 0.5

  ;; SUPPLY NETS
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      x=x+0.5
    )

  x = 0
  y = 0
  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("CLK" "WR")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-1
    )

  x = 18
  y = -2

  ;; OUTPUT
  printf("creating output pin\n")
    foreach(pinName list("CSEL" "ICLK" "NSAPREC" "WLEN" "SAE" "WEN" "NPRECH")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-dy
    )

  ;; CLK Delay
  inst = UvaEceSchematicCreateInst(cvid libName cellName_dlyWLbuffChain "symbol" "IDLY_WLEN_BChain"
		list(list("IN" "CLK"))
		list(list("OUT" "DLY_WLEN"))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		0.75:-0.75 "R0")

  ;;NOR gates
  inst = darUvaEceSchematicCreateInstParNand2(cvid libName cellName_nor "ITMNG_NOR0"
		"CLK"
		"DLY_WLEN"
		"GEN_SAE"
		"VDD"
		"VSS"
		3.5:-0.5)

  inst = darUvaEceSchematicCreateInstParNand2(cvid libName cellName_nor "ITMNG_NOR1"
		"CLK"
		"GEN_SAE"
		"X"
		"VDD"
		"VSS"
		6:0)

  inst = darUvaEceSchematicCreateInstParNand2(cvid libName cellName_nor "ITMNG_NOR3"
		"PRE_SAE"
		"CSEL"
		"PRE_SAPREC"
		"VDD"
		"VSS"
		12.5:0)

  ;;NAND gate
  inst = darUvaEceSchematicCreateInstParNand2(cvid libName cellName_nand "ITMNG_NAND2"
		"X"
		"NPRE_WEN"
		"NPRE_SAE"
		"VDD"
		"VSS"
		8.5:0)

  ;;AND gate
  inst = darUvaEceSchematicCreateInstParAnd2(cvid libName cellName_and "ITMNG_AND0"
		"WR"
		"CLK"
		"PRE_WEN"
		"VDD"
		"VSS"
		7:-2.5)

  ;;Inverters
  inst = darUvaEceSchematicCreateInstParInverter(cvid libName cellName_inverter "ITMNG_INV0"
		"WR"
		"NPRE_WEN"
		"VDD"
		"VSS"
		7:-1.25)

  inst = darUvaEceSchematicCreateInstParInverter(cvid libName cellName_inverter "ITMNG_INV1"
		"NPRE_SAE"
		"PRE_SAE"
		"VDD"
		"VSS"
		10.5:-0.5)

  inst = darUvaEceSchematicCreateInstParInverter(cvid libName cellName_inverter "ITMNG_INV2"
		"PRE_SAPREC"
		"PRE_NSAPREC"
		"VDD"
		"VSS"
		15:-0.5)

  inst = darUvaEceSchematicCreateInstParBuf(cvid libName cellName_buffer "ITMNG_BUF0"
		"PRE_SAPREC"
		"CSEL"
		"VDD"
		"VSS"
		15:-2)


  inputs = '("CLK" "PRE_NSAPREC" "CLK" "PRE_SAE" "PRE_WEN" "CLK")
  outputs = '("ICLK" "NSAPREC" "WLEN" "SAE" "WEN" "NPRECH")
  INames = list(cellName_ICLKbuffChain
		cellName_NSAPRECbuffChain
		cellName_WLENbuffChain
		cellName_SAEbuffChain
		cellName_WENbuffChain
		cellName_NPRECHbuffChain)

  ;;Buffer Chain for outputs

  x=15
  y=-3.5
  for(i 0 5
    in=nth(i inputs)
    out=nth(i outputs)
    cellViewName=nth(i INames)

    inst = UvaEceSchematicCreateInst(cvid libName cellViewName "symbol"
		sprintf(nil "I%s" cellViewName)
		list(list("IN" in))
		list(list("OUT" out))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		x:y "R0")

    y=y-dy
  )

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

/*
;;;;-----------------------------------
;;;; Main Entry
;;;;

let((libName cellName)

  libName="testLib"
  ;;define library location of FETs
  FETlibName = "NCSU_Devices_FreePDK45"

  ;;define the technology node
  technologyCase = "upper" ;;"45nmFreePDK"

  PMOScellName="PMOS_VTL"
  NMOScellName="NMOS_VTL"

  ;; Create ColDecoder
  cellName="TimingDAR"

  cellName_inverter = "INV"
  cellName_buffer = "BUFFER"
  cellName_nand = "NAND2"
  cellName_and = "AND2"
  cellName_nor = "NOR2"
  cellName_buffChain = "BChain"

  darCreateTimingBlockSchematic(libName cellName cellName_inverter cellName_buffer cellName_nand cellName_and cellName_nor cellName_buffChain)

)
*/
