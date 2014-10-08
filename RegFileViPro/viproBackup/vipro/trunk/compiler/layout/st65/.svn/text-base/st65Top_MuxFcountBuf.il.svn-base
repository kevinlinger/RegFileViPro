load("jwBasicLayout.il")

procedure( UvaEceCreateLayout(libName cellName )
  prog((cvid)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS 
    xy=0.1:0
    y=0

    for(i 0 5
	;Mux
	bBox = UvaEceLayoutCreateInst(cvid libName "HS65_LS_BFX62" "layout" sprintf(nil "IMUX%d" i) xy "R0" UvaEceBBoxLayerName)
	xy = UvaEceGetBboxCorners(bBox,"lowerRight")
    )


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
  UvaEceCreateLayout(libName "MUX_FCOUNT_BUF") 
)
