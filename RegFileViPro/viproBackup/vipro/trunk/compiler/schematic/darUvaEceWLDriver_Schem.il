;;;;-----------------------------------
/* This script creates the schematic for the 
   WL Driver block in st65

   By Satyanand Nalam, 03-05-2010
*/

/* Edited by Daniel Reyno, 01-04-2011 */

;;load("jwBasicSchematic.il")
;;load("./skill/darSchematic.il")


;;;;
;;;; To create schematic of complete WL Driver
;;;;
procedure(darUvaEceCreateWLDriverSchematic(libName cellName R cellName_WLDriver8)

  ;;prog(()

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
    foreach(pinName list("PRE8_6<0:7>" "PRE5_3<0:7>" "WLclk<0:7>" )
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

    ;; OUTPUT
    foreach(pinName list(sprintf(nil "WL<0:%d>" R-1))
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

    ;;;;-----------------------------------
    ;;;; WD8
    x=1
    y=-1
    for(r 0 R/8-1
        inst = UvaEceSchematicCreateInst(cvid libName cellName_WLDriver8 "symbol"
		sprintf(nil "IWLD_%d" r)
		list(list("A<0:7>" sprintf(nil "PRE8_6<%d>" ((r+1)*8-1)/64))
		     list("B<0:7>" sprintf(nil "PRE5_3<%d>" mod(((r+1)*8-1)/8 8)))
		     list("PRE8_6<0:7>" "PRE8_6<0:7>")
		     list("PRE5_3<0:7>" "PRE5_3<0:7>")
		     list("WLclk<0:7>" "WLclk<0:7>"))
		list(list("WL<0:7>" sprintf(nil "WL<%d:%d>" 8*r,8*r+7)))
		list(list("VDD" "VDD") list("VSS" "VSS"))
	  nil
	  x:y "R0")
	y = y+2
    )
			
  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

  ;;) ;end prog

) ;end CreateWLDriverSchematic

/*
;;;;-----------------------------------
;;;; Main Entry
;;;;
let((libName cellName R C )

  libName="testLib"	;;library location to place cell

  ;Rows
  R = 32

  cellName_WLDriver8 = "WLDriver8"

  ;; Create WL Driver
  sprintf(cellName "dar_WLDriver_%d" R)
  darUvaEceCreateWLDriverSchematic(libName cellName R cellName_WLDriver8)

)
*/