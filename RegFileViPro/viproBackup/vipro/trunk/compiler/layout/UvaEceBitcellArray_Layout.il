/* This script creates the Layout of the bitcell array
for R rows and C cols

----------------------
Leaf cells required:

----------------------

By Satyanand Nalam, 04-06-2010
*/

load("jwBasicLayout.il")

procedure( UvaEceCreateArrayLayout(libName cellName R C tapPitch cellHeight) 
  prog((cvid)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS - Add tap cell after every tapPitch rows
    xy=0:0
    y=0
;-------------------------------------------------------
    ;; Place bottom power and ground strap and corner cell
    for(c 0 C/2-1
        sprintf(fillerName "ITAPBF%d" c)
        bBox = UvaEceLayoutCreateInst(cvid libName "ARRAY_BOTTOM_FILLER" "layout" fillerName xy "R0" UvaEceBBoxLayerName)
        xy = UvaEceGetBboxCorners(bBox,"lowerRight")
    )
    bBox = UvaEceLayoutCreateInst(cvid libName "ARRAY_BOTCORNER_FILLER" "layout" "IBCNRF" xy "R0" UvaEceBBoxLayerName)
    xy_bf = UvaEceGetBboxCorners(bBox,"upperRight")
    y=yCoord(xy_bf)
;----------------------------------------------------

    ;; Place bitcells and right filler. Place well taps and tap filler cell every tapPitch number of rows
    for(r 0 R/2-1
      xy=0:y
      if( mod(r,tapPitch/2)==0 then
       for(c 0 C/2-1
          sprintf(instName "ITAPBC%d_%d" r,c)
          bBox = UvaEceLayoutCreateInst(cvid libName "bitcell_tap" "layout" instName xy "R0" UvaEceBBoxLayerName)
          xy = UvaEceGetBboxCorners(bBox,"lowerRight")
       )

       sprintf(fillerName "ITAPF%d" r)
       bBox = UvaEceLayoutCreateInst(cvid libName "bitcell_tap_filler" "layout" fillerName xy "R0" UvaEceBBoxLayerName)
       xy_tap = UvaEceGetBboxCorners(bBox,"upperRight")
       y = yCoord(xy_tap)
      )
      xy=0:y
      for(c 0 C/2-1
          sprintf(instName "IBC%d_%d" r c)
	  bBox = UvaEceLayoutCreateInst(cvid libName "bitcell6T_2x2" "layout" instName xy "R0"  UvaEceBBoxLayerName)
          xy = UvaEceGetBboxCorners(bBox,"lowerRight")
      )

     ; Add Right filler for connecting VSS
     sprintf(fillerName "IVSSF%d" r)
     bBox = UvaEceLayoutCreateInst(cvid libName "ARRAY_RIGHT_FILLER" "layout" fillerName xy "R0" UvaEceBBoxLayerName)

      xy_bc = UvaEceGetBboxCorners(bBox,"upperRight")
      y = yCoord(xy_bc)
   )

    ; Get top-left corner of array to start placing power connections
    xy = 0:y
    ; Place VDD filler cells at the top
    for(c 0 C/2-1
        sprintf(instName "IVDDF%d" c)
        bBox = UvaEceLayoutCreateInst(cvid libName "ARRAY_TOP_FILLER" "layout" instName xy "R0" UvaEceBBoxLayerName)
        xy = UvaEceGetBboxCorners(bBox,"lowerRight")
    )

    ; Add corner cell and get upper right for final array bbox
    bBox = UvaEceLayoutCreateInst(cvid libName "ARRAY_TOPCORNER_FILLER" "layout" "ITCNRF" xy "R0" UvaEceBBoxLayerName)
    pUR=UvaEceGetBboxCorners(bBox,"upperRight")


    ;;;; CREATE PINS
    for(r 0 R/2-1
     for(i 0 1
	net = dbMakeNet(cvid sprintf(nil "WL<%d>" 2*r+i))
	p1 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "IBC%d_0" r) sprintf(nil "WL<%d>" i) 1)
	UvaEceLayoutCreatePinAndLabel(cvid M3 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "WL<%d>" 2*r+i))
     )
    )

    for(c 0 C/2-1
     for(i 0 1
	netBL = dbMakeNet(cvid sprintf(nil "BL<%d>" 2*c+i))
	netBLB = dbMakeNet(cvid sprintf(nil "BLB<%d>" 2*c+i))
	pBL = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "IBC%d_%d" R/2-1 c) sprintf(nil "BL<%d>" i) 1)
	pBLB = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "IBC%d_%d" R/2-1 c) sprintf(nil "BLB<%d>" i) 1)
        UvaEceLayoutCreatePinAndLabel(cvid M2 list(UvaEceAddCoords(pBL -0.02:-0.02) UvaEceAddCoords(pBL 0.02:0.02)) netBL sprintf(nil "BL<%d>" 2*c+1))
        UvaEceLayoutCreatePinAndLabel(cvid M2 list(UvaEceAddCoords(pBLB -0.02:-0.02) UvaEceAddCoords(pBLB 0.02:0.02)) netBLB sprintf(nil "BLB<%d>" 2*c+i))
     )
    )

    foreach(pin '("VDD" "VSS")
	net = dbMakeNet(cvid sprintf(nil "%sC" pin))
        p1 = UvaEceLayoutFindInstPinCenter(cvid "ITCNRF" pin 1)
	UvaEceLayoutCreatePinAndLabel(cvid M3 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "%sC" pin))
    )
	
    ;;;; PLACE BOUNDARY
    pLL = 0:0
    jwLayoutCreateBbox(cvid list(pLL pUR))
    dbSave(cvid)
    dbClose(cvid)
    return(t)
  )
)

let((libName cellName tapPitch R C)
  R=4
  C=2
  cellHeight=0.56
  tapPitch=2 ;meaning a well-tap every 32 rows
  libName="highTempSRAM"
  sprintf(cellName "6TBITCELL_ARRAY_%dx%d" R C)
  ;UvaEceCreateArrayLayout(libName cellName R C tapPitch cellHeight) 
  UvaEceCreateArrayLayout(libName "testArray" R C tapPitch cellHeight) 
)
