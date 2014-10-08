load("jwBasicLayout.il")

procedure( UvaEceCreateLayout(libName cellName )
  prog((cvid)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS 

    svnTileCells(cvid libName "HS65_LS_IVX49" "IINV" 7 0.1:0 ?offset 0.2)
    svnTileCells(cvid libName "blkDecoder_std" "IBD" 1 0:4)
    svnTileCells(cvid libName "HS65_LS_BFX22" "IBUF1" 7 0.4:14 ?offset 0.8)
    svnTileCells(cvid libName "HS65_LS_BFX44" "IBUF2" 7 0:18)


    svnCreatePins(cvid "in" "ABLK" "IBD" M2 ?bus "sameInst" ?busWidth 3)
    svnCreatePins(cvid "vdd" "VDD" "IBD" M1)
    svnCreatePins(cvid "gnd" "VSS" "IBD" M1)
    svnCreatePins(cvid "Z" "NBLK_SEL" "IINV" M1 ?bus "multiInst" ?busWidth 7)
    svnCreatePins(cvid "Z" "BLK_SEL" "IBUF2" M1 ?bus "multiInst" ?busWidth 7)

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
  UvaEceCreateLayout(libName "BLOCK_DECODE") 
)
