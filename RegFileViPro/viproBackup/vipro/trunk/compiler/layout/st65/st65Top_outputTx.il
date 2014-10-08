load("jwBasicLayout.il")

procedure( UvaEceCreateLayout(libName cellName )
  prog((cvid)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS 
    xy=0:0
    y=0

    svnTileCells(cvid libName "HS65_LS_IVX4" "IINV" 16 1.8:0 ?offset 3.6)
    svnTileCells(cvid libName "HS65_LS_BFX44" "IBUF" 16 1:4 ?offset 2)
    svnTileCells(cvid libName "triinv_dout" "ITXG" 16 0:8)

    svnCreatePins(cvid "A" "DOUT_MEM" "IINV" M1 ?bus "multiInst" ?busWidth 16)
    svnCreatePins(cvid "OUT" "DOUT_BUS" "ITXG" M1 ?bus "multiInst" ?busWidth 16)

    svnCreatePins(cvid "VDD" "VDD" "ITXG0" M1)
    svnCreatePins(cvid "VSS" "VSS" "ITXG0" M1)
    svnCreatePins(cvid "TRI_N" "BLK_SEL" "ITXG0" M1)
    svnCreatePins(cvid "TRI_P" "NBLK_SEL" "ITXG0" M1)


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
  UvaEceCreateLayout(libName "OUTPUT_TX_STD") 
)
