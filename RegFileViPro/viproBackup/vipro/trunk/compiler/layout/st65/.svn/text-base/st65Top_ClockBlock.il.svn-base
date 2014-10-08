load("jwBasicLayout.il")

procedure( UvaEceCreateLayout(libName cellName )
  prog((cvid)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS 
    xy=0.4:0
    y=0

	;Mux
    bBox = UvaEceLayoutCreateInst(cvid libName "HS65_LS_MUX21X4" "layout" "IMUX" xy "R0" UvaEceBBoxLayerName)
    xy = UvaEceGetBboxCorners(bBox,"lowerRight")
    xy = xCoord(xy)+0.8:yCoord(xy)

    xy=0:4
    ;Buf
    bBox = UvaEceLayoutCreateInst(cvid libName "HS65_LS_AND2X35" "layout" "IAND" xy "R0" UvaEceBBoxLayerName)
    xy = UvaEceGetBboxCorners(bBox,"lowerRight")


    ;;;; CREATE PINS
    foreach(pin '("VDD" "VSS")
      net = dbMakeNet(cvid pin)
      p1 = UvaEceLayoutFindInstPinCenter(cvid "IMUX" pin 1)
      UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net pin)
    )

    net = dbMakeNet(cvid "CLK_SEL")
    p1 = UvaEceLayoutFindInstPinCenter(cvid "IMUX" "S0" 1)
    UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net "CLK_SEL")

    net = dbMakeNet(cvid "CLK_EN")
    p1 = UvaEceLayoutFindInstPinCenter(cvid "IAND" "A" 1)
    UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net "CLK
_SEL")

    foreach(pin '("CLKS" "CLKF")
	 net = dbMakeNet(cvid sprintf(nil "%s" pin))
	 in = case(pin ("CLKS" "D1") ("CLKF" "D0"))
	 p1 = UvaEceLayoutFindInstPinCenter(cvid "IMUX" in 1)
	 UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "%s" pin))
    )

    net = dbMakeNet(cvid "CLK")
    p1 = UvaEceLayoutFindInstPinCenter(cvid "IAND" "Z" 1)
    UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net "CLK")
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
  UvaEceCreateLayout(libName "CLOCK_BLOCK_STD") 
)
