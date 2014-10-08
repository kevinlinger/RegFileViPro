load("jwBasicLayout.il")

procedure( UvaEceCreateLayout(libName cellName )
  prog((cvid)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS 
    xy=0.6:0
    y=0

    svnTileCells(cvid libName "HS65_LS_MUX21X9" "IMUX" 6 xy ?offset 1.2)
    svnTileCells(cvid libName "HS65_LS_BFX62" "IBUF" 6 0:4 )

    svnCreatePins(cvid "D1" "fcount" "IMUX" M1 ?bus "multiInst" ?busWidth 6)
    svnCreatePins(cvid "D0" "DOUT" "IMUX" M1 ?bus "multiInst" ?busWidth 6)
    svnCreatePins(cvid "S0" "BIST_EN" "IMUX0" M1)
    svnCreatePins(cvid "VDD" "VDD" "IMUX0" M1)
    svnCreatePins(cvid "VSS" "VSS" "IMUX0" M1)
    svnCreatePins(cvid "Z" "DATA_OUT" "IBUF" M1 ?bus "multiInst" ?busWidth 6)

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
  UvaEceCreateLayout(libName "MUX_FCOUNT_STD") 
)
