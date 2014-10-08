;;;;-----------------------------------
/* This script creates the top-level predecode
   and timing block for the SRAM macro 
   R=rows C=cols DW=word-size col-mux=C/DW
   AR=row-addr bits
   AC=col-addr bits
   By Satyanand Nalam, 03-09-2010
*/

load("jwBasicSchematic.il")
   
;;;;-----------------------------------
;;;; Procedure to create Schematic
;;;; C=cols DW=word-size
;;;;-----------------------------------

procedure(UvaEceCreateTimingSchematic(libName cellName C DW)     

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
    foreach(pinName list("CSEL" "CSELB" "ICLK" "NICLK" "NPRECH" "NSAE" "NSAPREC" "SAE" "WEN" "WLEN")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

    ;; INPUT
    foreach(pinName list("WL_CTRL<0:1>" "SA_CTRL<0:1>" "WR" "CLK" "AR<0:8>" "AC<0:2>")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

    x=dx
    y=y-dy

    ;;;;-----------------------------------
    ;;;; Input Flops
    foreach(pinName list("WL_CTRL<0:1>" "SA_CTRL<0:1>" "WR" "CLK" "AR<0:8>" "AC<0:2>")
	inst = UvaEceSchematicCreateInst(cvid libName "io_latch" "symbol"
		sprintf(nil "I%s" pinName)
		list(list("CLK" "CLK")
		     list("D" sprintf(nil "%s" pinName)))
		list(list("Q" sprintf(nil "%s_CKD" pinName)))
		list(list("VDD" "VDD")) 
		list(list("VSS" "VSS")) 
                nil
                x:y "R0")
	y=y-dy
   )
    dbSave(cvid)
    dbClose(cvid)

  ) ;end prog

) ;end CreateTimingSchematic


;;;;-----------------------------------
;;;; Main Entry
;;;;
let((libName cellName C DW )

  libName="highTempSRAM"

  ;Architectural specs
  ;R
  ;AR
  ;AC
  C = 8
  DW = 2

  ;; Create Bitslice
  sprintf(cellName "svn2u_Timing_%d_%d" R C/DW)
  UvaEceCreateTimingSchematic(libName cellName C DW) 
  jwCreateSymbolFromSchematic(libName cellName)
  ;jwCheckSchematic(libName cellName)
)
