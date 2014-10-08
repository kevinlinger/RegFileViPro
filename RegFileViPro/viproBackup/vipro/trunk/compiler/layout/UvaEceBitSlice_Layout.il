/* This is the top-level script that creates the Layout of the SRAM by tiling together the array, peripherals and various filler cells

----------------------
Leaf cells required:
----------------------

By Satyanand Nalam, 04-08-2010
*/

load("jwBasicLayout.il")

procedure( UvaEceCreateBitSliceLayout(libName cellName IOName SAName CDName leftFillerName IOFillerName SAFillerName CDFillerName C W @key (IO_num 1) (SA_num 1) )
  prog((cvid)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS
    xy=0:0

    ;left filler for SAE connections
    ;bBox = UvaEceLayoutCreateInst(cvid libName leftFillerName  "layout" "IBSLF" xy "R0" UvaEceBBoxLayerName)
    ;xy = UvaEceGetBboxCorners(bBox,"lowerRight")
    x = xCoord(xy)

    ;IOx and filler - No: of instances to be placed depends on if the pitchmatching is 1-1 or n-n.
    for(w 0 W/IO_num-1
        sprintf(instName "IIO%d" w)
        bBox = UvaEceLayoutCreateInst(cvid libName IOName "layout" instName xy "R0"  UvaEceBBoxLayerName)
        xy = UvaEceGetBboxCorners(bBox,"lowerRight")
    )

    bBox = UvaEceLayoutCreateInst(cvid libName IOFillerName "layout" "IIORF" xy "R0" UvaEceBBoxLayerName)
    y = UvaEceGetBboxCorners(bBox,"upperRight")
    xy=x:yCoord(y)

    ;SAx and filler
    for(w 0 W/SA_num-1
        sprintf(instName "ISA%d" w)
        bBox = UvaEceLayoutCreateInst(cvid libName SAName "layout" instName xy "R0"
 UvaEceBBoxLayerName)
        xy = UvaEceGetBboxCorners(bBox,"lowerRight")
    )

    bBox = UvaEceLayoutCreateInst(cvid libName SAFillerName "layout" "ISARF" xy "R0" UvaEceBBoxLayerName)
    y = UvaEceGetBboxCorners(bBox,"upperRight")
    xy=x:yCoord(y)

    ; CDx and filler
    for(w 0 W-1
	sprintf(instName "ICD%d" w)
	bBox = UvaEceLayoutCreateInst(cvid libName CDName "layout" instName xy "R0" UvaEceBBoxLayerName)
	xy = UvaEceGetBboxCorners(bBox,"lowerRight")
    )

    bBox = UvaEceLayoutCreateInst(cvid libName CDFillerName "layout" "ICDRF" xy "R0" UvaEceBBoxLayerName)
    pUR = UvaEceGetBboxCorners(bBox,"upperRight")

    ;;;; ADD PINS
    ;; CD signals
    ; PCH
    net = dbMakeNet(cvid "PCH")
    p1 = UvaEceLayoutFindInstPinCenter(cvid "ICD0" "PCH" 1)
    UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net "PCH")

    ; CSEL/CSELB
    foreach(pin '("CSEL" "CSELB")
     for(i 0 C/W-1
	if(C/W == 1 then
		net = dbMakeNet(cvid sprintf(nil "%s" pin))
	        p1 = UvaEceLayoutFindInstPinCenter(cvid "ICD0" sprintf(nil "%s" pin) 1)
        	UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "%s" pin i))
	else
		net = dbMakeNet(cvid sprintf(nil "%s<%d>" pin i))
		p1 = UvaEceLayoutFindInstPinCenter(cvid "ICD0" sprintf(nil "%s<%d>" pin i) 1)
		UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "%s<%d>" pin i))
	)
     )
   )

   ; BL/BLB
   foreach(pin '("BL" "BLB")
    for(i 0 W-1
     for(j 0 C/W-1
	net = dbMakeNet(cvid sprintf(nil "%s<%d>" pin (C/W)*i+j))
        if(C/W == 1 then
        	p1 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "ICD%d" i) sprintf(nil "%s" pin) 1)
	else
		p1 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "ICD%d" i) sprintf(nil "%s<%d>" pin j) 1)	
	)
	UvaEceLayoutCreatePinAndLabel(cvid M2 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "%s<%d>" pin (C/W)*i+j))
     )
    )
   )
/*
   ;; SA signals
   ; SAE, SAPCH
   foreach(pin '("SAE" "SAPREC")
	net = dbMakeNet(cvid pin)
        p1 = UvaEceLayoutFindInstPinCenter(cvid "ISA0" pin 1)
	UvaEceLayoutCreatePinAndLabel(cvid M1 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net pin)
   )
*/
   ;David's SA
   foreach(pin '("PRE" "PREB")
	sig = case(pin ("PRE" "SAE") ("PREB" "SAPREC"))
        net = dbMakeNet(cvid sig)
        p1 = UvaEceLayoutFindInstPinCenter(cvid "ISA0" pin 1)
        UvaEceLayoutCreatePinAndLabel(cvid M3 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sig)
   )

   ;; IO signals, VDD and VSS -***** HARD-CODING OF METAL LAYERS FOR PIN NEEDS TO BE FIXED!!!******
   ; ICLK, OCLK, WEN, VDD, VSS
   foreach(pin '("ICLK" "OCLK" "WEN" "VDD" "VSS")
	net = dbMakeNet(cvid pin)
        p1 = UvaEceLayoutFindInstPinCenter(cvid "IIO0" pin 1)
	met = case(pin ("ICLK"||"OCLK"||"WEN"||"VDD" M3) ("VSS"||"VDD" M1))
	UvaEceLayoutCreatePinAndLabel(cvid met list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net pin)
   )

   ;DIN and DOUT
   foreach(pin '("DIN" "DOUT")
    for(i 0 W/IO_num-1
     for(j 0 IO_num-1
	net = dbMakeNet(cvid sprintf(nil "%s<%d>" pin IO_num*i+j))
	if(IO_num !=1 then
	  p1 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "IIO%d" i) sprintf(nil "%s<%d>" pin j) 1)
	else
	  p1 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "IIO%d" i) sprintf(nil "%s" pin) 1)	
	)
	UvaEceLayoutCreatePinAndLabel(cvid M2 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "%s<%d>" pin IO_num*i+j)) 
     )
    )
   )

   ;;;; PLACE BOUNDARY
   pLL = 0:0
   jwLayoutCreateBbox(cvid list(pLL pUR)) 
   dbSave(cvid)
   dbClose(cvid)
   return(t)
  )
)

let((libName cellName C W)
  C=16
  W=16
  libName="highTempSRAM"
  sprintf(cellName "BITSLICE_DMM_%d" C)
  sprintf(IOName "IO%d" C/W)
  ;sprintf(SAName "SA%d" C/W)
  SAName="SA_David"
  sprintf(CDName "CD%d" C/W)
  sprintf(leftFillerName "BITSLICE_LEFT_FILLER%d" C)
  sprintf(IOFillerName "IO_RIGHT_FILLER%d" C)
  sprintf(SAFillerName "SADMM_RIGHT_FILLER%d" C)
  sprintf(CDFillerName "CD_RIGHT_FILLER%d" C)
  UvaEceCreateBitSliceLayout(libName "testDavid" IOName SAName CDName leftFillerName IOFillerName SAFillerName CDFillerName C W ?IO_num 4 ) 
)
