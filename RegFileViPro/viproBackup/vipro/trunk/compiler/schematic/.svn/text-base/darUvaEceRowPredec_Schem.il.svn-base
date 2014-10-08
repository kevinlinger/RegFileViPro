;;;;-----------------------------------
/* This script creates the schematic for 
   predecode block in st65

   By Satyanand Nalam, 03-05-2010
*/

/* Edited by Daniel Reyno, 01-24-2011 */

load("./skill/jwBasicSchematic.il")
load("./skill/darSchematic.il")
   
;;;;-----------------------------------
;;;; Procedure to create Schematic
;;;; A=# of address bits
;;;;-----------------------------------

procedure(darUvaEceCreatePredecSchematic(libName cellName A cellName_inverter cellName_and)

  prog(()

    cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
    UvaEceDeleteObjectsSchematic(cvid)


    ;;; SECTION: SET schematic params
    dx = 4
    dy = 3

    ;;; SECTION: SET UP THE PINS
    x = 0
    y = 0

    ;; SUPPLY NETS
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

    ;; INPUT
    foreach(pinName list(sprintf(nil "A<0:%d>" A-1) "WLEN")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

    ;; INPUT-OUTPUT
    foreach(pinName list("PRE8_6<0:7>" "PRE5_3<0:7>" "WLclk<0:7>")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

    x=dx
    y=y+dy

    ;;;;-----------------------------------
    ;;;; inverters for (latched) address bits

    for(i 0 A-1
	inst = darUvaEceSchematicCreateInstParInverter(cvid libName cellName_inverter sprintf(nil "IInv%d" i)
		sprintf(nil "A<%d>" i)
		sprintf(nil "NA<%d>" i)
		"VDD"
		"VSS"
		x:y)

        x=x+dx
    )

    ;;;;-----------------------------------
    ;;;; predecode address bits in groups of 3
    ;;;; exploit the patterns of complemented and
    ;;;; uncomplemented input address bits
    ;;;; in the predecoder

    for(n 0 2
     for(i 0 1
      for(r 0 3
	sprintf(b0 "%d" 3*n)
	sprintf(b1 "%d" 3*n+1)
	B0 = 3*n
	B1 = 3*n+1
	b0B = case(modulo(r,2) (0 "N") (t ""))
	b1B = case(r ((0 1) "N") (t ""))

	inst = darUvaEceSchematicCreateInstParAnd2(cvid libName cellName_and
		sprintf(nil "IAndIN%d%d%d%d" B1 B0 i r)
		sprintf(nil "%sA<%s>" b0B b0)
		sprintf(nil "%sA<%s>" b1B b1)
		sprintf(nil "%sA%s%sA%s_%d" b1B b1 b0B b0 i)
		"VDD"
		"VSS"
		x:y)

	x=x+dx

	sprintf(b2 "%d" 3*n+2)

	B2 = 3*n+2

	b2B = case(i (0 "N") (t ""))

	if(n!=0 then
		inst= darUvaEceSchematicCreateInstParAnd2(cvid libName cellName_and
			sprintf(nil "IAndIN%d%d%d%d" B2 B1 B0 4*i+r)
			sprintf(nil "%sA<%s>" b2B b2)
			sprintf(nil "%sA%s%sA%s_%d" b1B b1 b0B b0 i)
			sprintf(nil "PRE%d_%d<%d>" B2 B0 4*i+r)
			"VDD"
			"VSS"
			x:y)

	else
		inst = darUvaEceSchematicCreateInstParAnd2(cvid libName cellName_and
			sprintf(nil "IAndIN%d%d%d%d" B2 B1 B0 4*i+r)
			sprintf(nil "%sA<%s>" b2B b2)
			sprintf(nil "%sA%s%sA%s_%d" b1B b1 b0B b0 i)
			sprintf(nil "PRE%d_%d<%d>" B2 B0 4*i+r)
			"VDD"
			"VSS"
			x:y)

	)
	y=y+dy
	x=x-dx
      ) ;end for r
     ) ;end for i
     x=x+3*dx
     y=y-8*dy
    ) ;end for n

    ;;;;-----------------------------------
    ;;;; predecoded output for A<2:0>
    ;;;; ANDed with WL enable to generate
    ;;;; WLclk<0:7>

    x=x+dx
    for(i 0 7
	inst = darUvaEceSchematicCreateInstParAnd2(cvid libName cellName_and sprintf(nil "IAndIN%d" i)
		"WLEN"
		sprintf(nil "PRE2_0<%d>" i)
		sprintf(nil "WLclk<%d>" i)
		"VDD"
		"VSS"
		x:y)
    y=y+dy

    )

   x=dx
   y=-2*dy 


    ;; save schematic and close schematic window	
    dbSave(cvid)
    dbClose(cvid)

    jwCheckSchematic(libName cellName)

    jwCreateSymbolFromSchematic(libName cellName)

  ) ;end prog

) ;end CreateRowPredecSchematic

/*
;;;;-----------------------------------
;;;; Main Entry
;;;;
let((libName cellName  R C )

  libName="testLib"

  ;Max address bits
  A = 9

  cellName="dar_Predec_test"
  cellName_inverter="INV"
  cellName_and="AND2"

  ;; Create Row Predecoder
  ;;sprintf(cellName "dar_Predec_test" A)
  darUvaEceCreatePredecSchematic(libName cellName A cellName_inverter cellName_and)

  ;;jwCreateSymbolFromSchematic(libName cellName)
  ;;jwCheckSchematic(libName cellName)

)
*/