;;;;-----------------------------------
/* This script creates the schematic for 6T bitcell

   By Daniel Reyno, 12-05-2011
*/

;;load("jwBasicSchematic.il")
load("./skill/darSchematic.il")

;;;;-----------------------------------
;;;; Procedure to create Schematic
;;;;-----------------------------------

procedure( darCreateArraySchematic(libName cellName rows columns cellName_bitcell)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; SUPPLY NETS
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y+0.5
    )

 ;; WL Pin
    foreach(pinName list(sprintf(nil "WL<0:%d>" rows-1))
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y+0.5
    )

  ;; BL Pin
    foreach(pinName list(sprintf(nil "BL<0:%d>" columns-1))
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y+0.5
    )

  ;; BLB Pin
    foreach(pinName list(sprintf(nil "BLB<0:%d>" columns-1))
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
    )

  ;; INSTANCES of Bitcells
  ;;set x,y coordinates for placement of bitcells
  ;;parameter 'a' allows continuous naming of bitcell instances
  x=1
  y=0
  a=0

  ;;double for loop to create array
  ;;first for loop creates the number of rows, second for loop creates the number of columns
  for(r 0 (rows - 1)

    printf("Instantiating row ")
    println(r)

    for(c 0 (columns - 1)

      ;;instantiate bitcell
      inst = UvaEceSchematicCreateInst(cvid libName cellName_bitcell "symbol"
		sprintf(nil "BC%d_%d" r c)
		list(list("WL" sprintf(nil "WL<%d>" r)))
		nil
		list(list("BL" sprintf(nil "BL<%d>" c))
		     list("BLB" sprintf(nil "BLB<%d>" c))
		     list("VDD" "VDD") list("VSS" "VSS"))
		nil
		x:y "R0")

    x=x+2
    )	;;close first for loop

  x=1		;;reset x value to left side of array
  y=y+2		;;increase y to build array vertically up

  )	;;close second for loop

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

/*
;;;;-----------------------------------
;;;; Main Entry
;;;;
let((libName cellName R C )

  libName="ViPro"	;;library location to place cell

  technologyCase="upper"	;;45nm Free PDK

  FETlibName="NCSU_Devices_FreePDK45"	;;library location of FETs

  PMOScellName="PMOS_VTL"	;;type of PMOS
  NMOScellName="NMOS_VTL"	;;type of NMOS

  ;Rows and Cols
  R = 128
  C = 16

  ;; Create 6T array
  cellName_bitcell = "bitcell"
  darCreateBitcellSchematic(libName cellName_bitcell FETlibName PMOScellName NMOScellName technologyCase)
  sprintf(cellName "dar6Tbitcell_Array_%dx%d" R C)
  darCreateArraySchematic(libName cellName R C cellName_bitcell)

)
*/
