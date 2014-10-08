load("jwBasicLayout.il")

procedure( UvaEceCreateLayout(libName cellName )
  prog((cvid bBox)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS 

    svnTileCells(cvid libName "HS65_LS_NOR2X2" "INOR" 1 0:0)
    svnTileCells(cvid libName "HS65_LS_IVX4" "IINVSK" 1 0:4)
    svnTileCells(cvid libName "HS65_LS_NAND2X14" "INAND" 7 0.4:8 ?offset 0.8) 
    svnTileCells(cvid libName "HS65_LS_IVX62" "IINV" 7 0:12)

    svnCreatePins(cvid "B" "BLK_SEL" "INAND" M1 ?bus "multiInst" ?busWidth 5 ?instOffset 1)
    svnCreatePins(cvid "B" "BLK_SEL<5>" "INOR" M1)
    svnCreatePins(cvid "A" "BLK_SEL<6>" "INOR" M1)
    svnCreatePins(cvid "A" "CLK" "INAND0" M1)
    svnCreatePins(cvid "VDD" "VDD" "INAND0" M1)
    svnCreatePins(cvid "VSS" "VSS" "INAND0" M1)
    svnCreatePins(cvid "Z" "CLK_BIST" "IINV6" M1)
    svnCreatePins(cvid "Z" "CLK_GTD<5>" "IINV0" M1)
    svnCreatePins(cvid "Z" "CLK_GTD" "IINV" M1 ?bus "multiInst" ?busWidth 5 ?instOffset 1)

    ;;;; PLACE BOUNDARY
    ;pLL = 0:0
    ;jwLayoutCreateBbox(cvid list(pLL pUR))
    dbSave(cvid)
    dbClose(cvid)
    return(t)
  )
)

let((libName cellName tapPitch R C)
  libName="highTempSRAM"
  UvaEceCreateLayout(libName "CLK_GATE_STD") 
)
