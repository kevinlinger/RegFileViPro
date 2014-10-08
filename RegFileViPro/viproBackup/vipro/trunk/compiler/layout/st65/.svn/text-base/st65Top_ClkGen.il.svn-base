load("jwBasicLayout.il")

procedure( UvaEceCreateLayout(libName cellName )
  prog((cvid bBox)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS 

    xy = svnTileCells(cvid libName "CLOCK_BLOCK_STD" "ICLKBLK" 1 0:0)
    svnTileCells(cvid libName "CLK_GATE_STD" "ICKGT" 1 xy)

    svnCreatePins(cvid "CLKF" "CLKF" "ICLKBLK" M1)
    svnCreatePins(cvid "CLKS" "CLKS" "ICLKBLK" M1)
    svnCreatePins(cvid "CLK_EN" "CLKEN" "ICLKBLK" M1)
    svnCreatePins(cvid "CLK_SEL" "CLKSEL" "ICLKBLK" M1)

    svnCreatePins(cvid "CLK_BIST" "CLK_BIST" "ICKGT" M1)
    svnCreatePins(cvid "VDD" "VDD" "ICKGT" M1)
    svnCreatePins(cvid "VSS" "VSS" "ICKGT" M1)

    svnCreatePins(cvid "BLK_SEL" "BLK_SEL" "ICKGT" M1 ?bus "sameInst" ?busWidth 7)
    svnCreatePins(cvid "CLK_GTD" "CLK_GTD" "ICKGT" M1 ?bus "sameInst" ?busWidth 6)

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
  UvaEceCreateLayout(libName "CLOCK_GEN_STD") 
)
