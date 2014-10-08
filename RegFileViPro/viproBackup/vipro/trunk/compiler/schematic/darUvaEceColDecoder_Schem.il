;;;;-----------------------------------
/* This script creates the schematic for the
   3 to 8 col Decoder in st65. Max col-mux
   of 8 is assumed

   By Satyanand Nalam, 03-09-2010
*/

/* Edited by Daniel Reyno, 01-27-2011 */

;;load("jwBasicSchematic.il")
load("./skill/darSchematic.il")

;;;;-----------------------------------
;;;; Procedure to create Schematic
;;;;-----------------------------------

procedure(darUvaEceCreateColDecSchematic(libname cellName cellName_inverter cellName_and @key (wpInv wpMin) (wnInv wnMin) (lpInv lpMin) (lnInv lnMin))

  prog(()

    cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
    UvaEceDeleteObjectsSchematic(cvid)

    ;;; SECTION: SET schematic params
    dx = 3
    dy = 1.5

    x = 0
    y = 0

    IN = 3
    OUT = 8

    ;; SUPPLY NETS
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

    ;; INPUTS
    foreach(pinName list(sprintf(nil "in<0:%L>" IN-1))
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

    ;; OUTPUTS
    foreach(pinName list(sprintf(nil "out<0:%L>" OUT-1))
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

    x = dx/2
    y = 0

    for(r 0 IN-1
      inst = darUvaEceSchematicCreateInstParInverter(cvid libName cellName_inverter sprintf(nil "IInvIN%L" r)
		sprintf(nil "in<%L>" r)
		sprintf(nil "inB<%L>" r)
		"VDD"
		"VSS"
		x:y
		?wp wpInv ?wn wnInv ?lp lpInv ?ln lnInv)

      x=x+dx
    )

    x = dx/2
    y = y-dy


  stringlist=list()
  for(r 0 3
        b0="0"
	b1="1"
	b0B = case(modulo(r,2) (0 "B") (t ""))
	b1B = case(r ((0 1) "B") (t ""))


	inst = darUvaEceSchematicCreateInstParAnd2(cvid libName cellName_and sprintf(nil "IAndIN%L" r)
		sprintf(nil "in%s<%s>" b1B b1)
		sprintf(nil "in%s<%s>" b0B b0)
		sprintf(nil "in%s%s%s%s" b0 b0B b1 b1B)
		"VDD"
		"VSS"
		x:y)

          stringlist=append(stringlist list(list(sprintf(nil "%L" r) 
	    sprintf(nil "in%s%s%s%s" b0 b0B b1 b1B))))

        x=x+dx
   )

   for(r 4 5
        b0="2"
	if( r==4 then
	    b0B = "B"
	else 
	    b0B = ""
	)

	inst = darUvaEceSchematicCreateInstParAnd2(cvid libName cellName_and sprintf(nil "IAndIN%L" r)
		sprintf(nil "in%s<%s>" b0B b0)
		sprintf(nil "in%s<%s>" b0B b0)
		sprintf(nil "in%s%s%s%s" b0 b0B b0 b0B)
		"VDD"
		"VSS"
		x:y)

        stringlist=append(stringlist list(list(sprintf(nil "%L" r)
	    sprintf(nil "in%s%s%s%s" b0 b0B b0 b0B))))
        x=x+dx
   )

  for(r 0 OUT-1
	a0 = modulo(r 4)
	a1 = r/4+4

	inst = darUvaEceSchematicCreateInstParAnd2(cvid libName cellName_and sprintf(nil "IAndOUT%L" r)
		sprintf(nil "%s" cadr(assoc(sprintf(nil "%d" a1) stringlist)))
		sprintf(nil "%s" cadr(assoc(sprintf(nil "%d" a0) stringlist)))
		sprintf(nil "out<%d>" r)
		"VDD"
		"VSS"
		x:y)

        y=y+dy
  )

  dbSave(cvid)
  dbClose(cvid)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

) ; end prog

) ; end CreateColDecSchematic

/*
;;;;-----------------------------------
;;;; Main Entry
;;;;

let((libName cellName)

  libName="testLib"

  ;; Create ColDecoder
  cellName="colDecoder"

  cellName_inverter="INV"
  cellName_and="AND2"

  darUvaEceCreateColDecSchematic(libName cellName cellName_inverter cellName_and)
  ;;jwCreateSymbolFromSchematic(libName cellName)
  ;;jwCheckSchematic(libName cellName)
)
*/