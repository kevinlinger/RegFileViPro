load("jwBasicLayout.il")

procedure( UvaEceCreateLayout(libName cellName )
  prog((cvid)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS 
    xy=0.1:0
    y=0

    for(i 0 25
	;Mux
	bBox = UvaEceLayoutCreateInst(cvid libName "HS65_LS_MUX21X9" "layout" sprintf(nil "IMUX%d" i) xy "R0" UvaEceBBoxLayerName)
	xy = UvaEceGetBboxCorners(bBox,"lowerRight")
	xy = xCoord(xy)+0.2:yCoord(xy)
    )

    xy=0:4
    for(i 0 25
	;Buf
	bBox = UvaEceLayoutCreateInst(cvid libName "HS65_LS_BFX31" "layout" sprintf(nil "IBUF%d" i) xy "R0" UvaEceBBoxLayerName)
	xy = UvaEceGetBboxCorners(bBox,"lowerRight")
    )


    ;;;; CREATE PINS
    foreach(pin '("VDD" "VSS")
      net = dbMakeNet(cvid pin)
      p1 = UvaEceLayoutFindInstPinCenter(cvid "IMUX0" pin 1)
      UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net pin)
    )

    net = dbMakeNet(cvid "BIST_EN")
    p1 = UvaEceLayoutFindInstPinCenter(cvid "IMUX0" "S0" 1)
    UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net "BIST_EN")

   for(i 0 15
	foreach(pin '("BIST" "EXT" "MEM")
	 net = dbMakeNet(cvid sprintf(nil "DIN_%s<%d>" pin i))
	 in = case(pin ("BIST" "D1") ("EXT" "D0") ("MEM" "Z"))
	 cell = case(pin ("BIST"||"EXT" "MUX") ("MEM" "BUF"))
	 p1 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "I%s%d" cell i) in 1)
	 UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "DIN_%s<%d>" pin i))
        )
   )

   for(i 16 24
        foreach(pin '("BIST" "EXT" "MEM")
         net = dbMakeNet(cvid sprintf(nil "AR_%s<%d>" pin i-16))
         in = case(pin ("BIST" "D1") ("EXT" "D0") ("MEM" "Z"))
	 cell = case(pin ("BIST"||"EXT" "MUX") ("MEM" "BUF"))
         p1 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "I%s%d" cell i) in 1)
         UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "AR_%s<%d>" pin i-16))
        )
   )

   foreach(pin '("BIST" "EXT" "MEM")
	net = dbMakeNet(cvid sprintf(nil "WR_%s" pin))
	in = case(pin ("BIST" "D1") ("EXT" "D0") ("MEM" "Z"))
	cell = case(pin ("BIST"||"EXT" "MUX") ("MEM" "BUF"))
	p1 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "I%s25" cell) in 1)
	UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "WR_%s" pin ))
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
  UvaEceCreateLayout(libName "MUX_MEM_INPUT_STD") 
)
