load("jwBasicLayout.il")

procedure( UvaEceCreateLayout(libName cellName )
  prog((cvid)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    ;UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS 
    xy=1.1:0
    y=0
/*
    for(i 0 1
     for(j 0 14
	cell = case(i (0 "HS65_LS_BFX7") (t "HS65_LS_BFX62"))
	bBox = UvaEceLayoutCreateInst(cvid libName cell "layout" sprintf(nil "IBUF%d%d" i j) xy "R0" UvaEceBBoxLayerName)
	xy = UvaEceGetBboxCorners(bBox,"lowerRight")
	x = case(i (0 xCoord(xy)+2.2) (t xCoord(xy)))
	xy = x:yCoord(xy)
     )
     xy = 0:4
    )
*/

    svnCreatePins(cvid "A" "BIST_DONE" "IBUF00" M1)
    svnCreatePins(cvid "Z" "BIST_DONE_BUF" "IBUF10" M1)

    svnCreatePins(cvid "A" "FCOUNT" "IBUF0" M1 ?bus "multiInst" ?busWidth 14 ?instOffset 1)
    svnCreatePins(cvid "Z" "FCOUNT_BUF" "IBUF1" M1 ?bus "multiInst" ?busWidth 14 ?instOffset 1)

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
  UvaEceCreateLayout(libName "BIST_OUT_BUF") 
)
