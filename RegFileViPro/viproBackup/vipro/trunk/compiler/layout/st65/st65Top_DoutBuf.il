load("jwBasicLayout.il")

procedure( UvaEceCreateLayout(libName cellName )
  prog((cvid)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS 
    xy=0:0
    y=0

    svnTileCells(cvid libName "HS65_LS_MUX21X4" "IMUX" 4 3.2:0)
    svnTileCells(cvid libName "HS65_LS_BFX2" "IBUF" 16 0:4)

    svnCreatePins(cvid "D1" "DATA8" "IMUX" M1 ?bus "multiInst" ?busWidth 4 ?busOffset 4)
    svnCreatePins(cvid "D0" "DATA8" "IMUX" M1 ?bus "multiInst" ?busWidth 4 )
    svnCreatePins(cvid "S0" "SEL" "IMUX0" M1)
    svnCreatePins(cvid "VDD" "VDD" "IMUX0" M1)
    svnCreatePins(cvid "VSS" "VSS" "IMUX0" M1)
    svnCreatePins(cvid "Z" "DATA16" "IBUF" M1 ?bus "multiInst" ?busWidth 16)

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
  UvaEceCreateLayout(libName "DOUT_BUF_STD") 
)
