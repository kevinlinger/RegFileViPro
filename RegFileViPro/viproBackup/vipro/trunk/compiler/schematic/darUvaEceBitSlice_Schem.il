;;;;-----------------------------------
/* This script creates the column periphery for 6T bitcell 
   array in st65. This includes the column mux, SA and I/O 
   drivers.
   C=cols DW=word-size col-mux=C/DW
   By Satyanand Nalam, 03-05-2010
*/

/* Edited by Daniel Reyno, 01-12-2011 to work with automatic
   generation of lower level components, i.e. Sense Amp, I/O
   Circuits, etc.
*/

;load("jwBasicSchematic.il")
   
;;;;-----------------------------------
;;;; Procedure to create Schematic
;;;; C=cols DW=word-size
;;;;-----------------------------------

procedure(darUvaEceCreateBitSliceSchematic(libName cellName cellName_SA cellName_IO cellName_CD C DW)

  prog(()

    cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
    UvaEceDeleteObjectsSchematic(cvid)


    ;;; SECTION: SET schematic params
    dx = 3
    dy = 3

    ;;; SECTION: SET UP THE PINS
    x = 0
    y = 0

    ;; INPUT-OUTPUT
    if(DW != 1 then
      foreach(pinName list("VDD" "VSS" sprintf(nil "BL<0:%d>" C-1) sprintf(nil "BLB<0:%d>" C-1) )
        pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
        y=y-0.5
      )

      foreach(pinName list("SAE" "SAPREC" "ICLK" "OCLK" "WEN" "PCH" "CSEL<0:7>" "CSELB<0:7>" sprintf(nil "DIN<0:%d>" DW-1))
        pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
        y=y-0.5
      )
    ;; OUTPUT
      foreach(pinName list(sprintf(nil "DOUT<0:%d>" DW-1))
        pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
        y=y-0.5
      )
    else
      foreach(pinName list("VDD" "VSS" sprintf(nil "BL<0:%d>" C-1) sprintf(nil "BLB<0:%d>" C-1))
        pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
        y=y-0.5
      )

      foreach(pinName list("SAE" "SAPREC" "ICLK" "OCLK" "WEN" "PCH" "CSEL<0:7>" "CSELB<0:7>" "DIN<0>")
        pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
        y=y-0.5
      )
    ;; OUTPUT
      foreach(pinName list("DOUT<0>")
        pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
        y=y-0.5
      )
    )


    x=dx
    y=-dy

    ;;;;-----------------------------------
    ;;;; SA - not robust enough yet - had to change pin names for david's SA
    ;;;; *Edited by Daniel Reyno to work with automatic SenseAmp creation.
    ;;;; Changed instantiation of sense amp for pin types.*

    for(d 0 DW-1
      inst = UvaEceSchematicCreateInst(cvid libName cellName_SA "symbol"
             sprintf(nil "ISA_%d" d)
             list(list("SAE" "SAE") list("SAPREC" "SAPREC"))
             list(list("SD" sprintf(nil "SD<%d>" d)))
             list(list("RDWR" sprintf(nil "RDWR<%d>" d))
               list("NRDWR" sprintf(nil "NRDWR<%d>" d))
               list("VSS" "VSS") list("VDD" "VDD"))
             nil
             x:y "R0")
       x = x+dx
        )

    x=dx
    y=y-dy

    ;;;;-----------------------------------
    ;;;; IO
    ;;;; *Edited by DAR. Changed instantiation of I/O circuit
    ;;;; to account for pin types.
    for(d 0 DW-1
	inst = UvaEceSchematicCreateInst(cvid libName cellName_IO "symbol"
		sprintf(nil "IIO_%d" d)
		list(list("ICLK" "ICLK")
                     list("OCLK" "OCLK")
                     list("WEN" "WEN")
                     list("DIN" sprintf(nil "DIN<%d>" d))
                     list("SD" sprintf(nil "SD<%d>" d)))
		list(list("DOUT" sprintf(nil "DOUT<%d>" d)))
		list(list("RDWR" sprintf(nil "RDWR<%d>" d))
		     list("NRDWR" sprintf(nil "NRDWR<%d>" d))
		     list("VSS" "VSS") list("VDD" "VDD"))
		nil
		x:y "R0")
	x = x+dx
	)

    x=dx
    y=y+dy+dy

    ;;;;-----------------------------------
    ;;;; CD - special case for no col-mux

    if( C/DW !=1 then
     for(d 0 DW-1
        inst = UvaEceSchematicCreateInst(cvid libName cellName_CD "symbol"
	        sprintf(nil "ICD%d_%d" C/DW,d)
	        list(list(sprintf(nil "CSEL<0:%d>" C/DW-1) sprintf(nil "CSEL<0:%d>" C/DW-1))
	          list(sprintf(nil "CSELB<0:%d>" C/DW-1) sprintf(nil "CSELB<0:%d>" C/DW-1))
		  list("PCH" "PCH"))
	        nil
	        list(list(sprintf(nil "BL<0:%d>" C/DW-1) sprintf(nil "BL<%d:%d>" (C/DW)*d,(C/DW)*d+C/DW-1 ))
	        list(sprintf(nil "BLB<0:%d>" C/DW-1) sprintf(nil "BLB<%d:%d>" (C/DW)*d,(C/DW)*d+C/DW-1 ))
                  list("RDWR" sprintf(nil "RDWR<%d>" d))
                  list("NRDWR" sprintf(nil "NRDWR<%d>" d))
                  list("VSS" "VSS") list("VDD" "VDD"))
                nil
	        x:y "R0")
	x = x+dx
     )
     else
      for(d 0 DW-1
         inst = UvaEceSchematicCreateInst(cvid libName cellName_CD "symbol"
                  sprintf(nil "ICD%d_%d" C/DW,d)
                  list(list("CSEL" "CSEL<0>")
                    list("CSELB" "CSELB<0>")
                    list("PCH" "PCH"))
                  nil
                  list(list("BL" sprintf(nil "BL<%d>" d))
                    list("BLB" sprintf(nil "BLB<%d>" d))
                    list("RDWR" sprintf(nil "RDWR<%d>" d))
                    list("NRDWR" sprintf(nil "NRDWR<%d>" d))
                    list("VSS" "VSS") list("VDD" "VDD"))
                  nil
                  x:y "R0")
          x = x+dx
     )
    )
    x=dx
    y=y-dy

/*
    ;;;;-----------------------------------
    ;;;; CD - special case for no col-mux

    if( C/DW !=1 then
     for(d 0 DW-1
        inst = UvaEceSchematicCreateInst(cvid libName sprintf(nil "CD%d" C/DW) "symbol"
	          sprintf(nil "ICD%d_%d" C/DW,d)
	      list(list("VSS" "VSS")
                   list("VDD" "VDD")
		   list(sprintf(nil "CSEL<0:%d>" C/DW-1) sprintf(nil "CSEL<0:%d>" C/DW-1))
	           list(sprintf(nil "CSELB<0:%d>" C/DW-1) sprintf(nil "CSELB<0:%d>" C/DW-1))
		   list("PCH" "PCH"))
	      nil
	      list(list(sprintf(nil "BL<0:%d>" C/DW-1) sprintf(nil "BL<%d:%d>" (C/DW)*d,(C/DW)*d+C/DW-1 ))
	           list(sprintf(nil "BLB<0:%d>" C/DW-1) sprintf(nil "BLB<%d:%d>" (C/DW)*d,(C/DW)*d+C/DW-1 )))
              list(list("RDWR" sprintf(nil "RDWR<%d>" d))
                   list("NRDWR" sprintf(nil "NRDWR<%d>" d)))
	      x:y "R0")
	    x = x+dx
     ) 
     else
      for(d 0 DW-1
         inst = UvaEceSchematicCreateInst(cvid libName sprintf(nil "CD%d" C/DW) "symbol"
                  sprintf(nil "ICD%d_%d" C/DW,d)
              list(list("VSS" "VSS")
                   list("VDD" "VDD")
                   list("CSEL" "CSEL")
                   list("CSELB" "CSELB")
                   list("PCH" "PCH"))
              nil  
              list(list("BL" sprintf(nil "BL<%d>" d))
                   list("BLB" sprintf(nil "BLB<%d>" d)))
              list(list("RDWR" sprintf(nil "RDWR<%d>" d))
                   list("NRDWR" sprintf(nil "NRDWR<%d>" d)))
              x:y "R0")
            x = x+dx
     )
    )
    x=dx
    y=y-dy
*/

    dbSave(cvid)
    dbClose(cvid)

    printf("=== Cell %L schematic has been created! ===\n", cellName)

    jwCheckSchematic(libName cellName)

    jwCreateSymbolFromSchematic(libName cellName)


  ) ;end prog

) ;end CreateBitSliceSchematic

/*
;;;;-----------------------------------
;;;; Main Entry
;;;;
let((libName cellName C DW )

  libName="highTempSRAM"

  ;Cols and Word-size
  C = 16
  DW = 16

  ;; Create Bitslice
  sprintf(cellName "BITSLICE_%d" C)
  UvaEceCreateBitSliceSchematic(libName cellName C DW) 
  jwCreateSymbolFromSchematic(libName cellName)
  ;jwCheckSchematic(libName cellName)

)
*/
