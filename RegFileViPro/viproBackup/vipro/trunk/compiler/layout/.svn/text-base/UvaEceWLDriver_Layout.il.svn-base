/* This script creates the Layout of the WLDriver block
for R rows - R should be a POWER OF 2 AND >8

Optional Arguments - via names default to M2X_M1 and M3X_M3X corresponding to st65, and assuming two different layers of horizontal metals

The code should work if only one metal layer is used horizontally - just make the two via names the same.
It should also work if the metal layers are not M1,M2,M3 but any other consecutive combination like M2,M3,M4
 - provided the vertical lines are in the middle one. This is because the current code drops only one via.

----------------------
Leaf cells required:
1. WLDriver8 - The second decoder stage and final WL driver for 8 cells, pitchmatched
2. WLDriver_tap - Tap cell to be inserted every tapPitch number of stages
3. WLDRIVER_FILLER - Connect the VDD and VSS approporiately
Could move the filler over to the final top-level layout script. Here currently for LVS reasons
----------------------

By Satyanand Nalam, 04-05-2010
*/

load("jwBasicLayout.il")

procedure( UvaEceCreateWLDriverLayout(libName cellName wldCellName topFillerName botFillerName tapName R tapPitch @key (lowMetalVia "M2X_M1") (highMetalVia "M3X_M2X")) 
  prog((cvid)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS - Add tap cell after every tapPitch rows and add filler at the top
    xy=0:0

    ;place bottom filler
    bBox = UvaEceLayoutCreateInst(cvid libName botFillerName "layout" "IWLDBFL" xy "R0" UvaEceBBoxLayerName)
    xy = UvaEceGetBboxCorners(bBox,"upperLeft")


    for(r 0 R/8-1
	if( mod(r,tapPitch/8)==0 && (r !=0) then
		sprintf(instName "ITAP%d" r)
		bBox = UvaEceLayoutCreateInst(cvid libName tapName "layout" instName xy "R0" UvaEceBBoxLayerName)
		xy = UvaEceGetBboxCorners(bBox,"upperLeft")
	)
	sprintf(instName "IWLD8%d" r)
	bBox = UvaEceLayoutCreateInst(cvid libName wldCellName "layout" instName xy "R0" UvaEceBBoxLayerName)
	xy = UvaEceGetBboxCorners(bBox,"upperLeft")
    )
    xy1= UvaEceGetBboxCorners(bBox,"upperRight")
    bBox = UvaEceLayoutCreateInst(cvid libName topFillerName "layout" "IWLDFILL" xy "R0" UvaEceBBoxLayerName)
    xy2= UvaEceGetBboxCorners(bBox,"upperRight")
    pUR = xCoord(xy1):yCoord(xy2)


    ;;;; ADD PINS
    ;WL<i>
    for(r 0 R/8-1
	for(i 0 7
		net = dbMakeNet(cvid sprintf(nil "WL<%d>" 8*r+i))
		p1 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "IWLD8%d" r) sprintf(nil "WL<%d>" i) 1)
		UvaEceLayoutCreatePinAndLabel(cvid M3 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "WL<%d>" 8*r+i))
	)
    )

    ;PRE*, WLclk
    sprintf(topInst "IWLD8%d" R/8-1)
    foreach(pin '("PRE8_6" "PRE5_3" "WLclk")
	for(i 0 7
		net = dbMakeNet(cvid sprintf(nil "%s<%d>" pin i))
		p1 = UvaEceLayoutFindInstPinCenter(cvid topInst sprintf(nil "%s<%d>" pin i) 1)
		UvaEceLayoutCreatePinAndLabel(cvid M2 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "%s<%d>" pin i))
	)
    )

    ;VSS and VDD
    foreach(pin '("VDD" "VSS")
        net = dbMakeNet(cvid pin)
        p1 = UvaEceLayoutFindInstPinCenter(cvid "IWLD80" pin 1)
        UvaEceLayoutCreatePinAndLabel(cvid M2 list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net pin)
    )


    ;PROGRAM THE VIAS

   foreach(pre '("PRE8_6" "PRE5_3")
    for(r 0 R/8-1

       ; Find location of PRE*<> that connects to A/B<0:7> in the rth WLDriver8
       ; Same expression as in schematic code
       preNum = case(pre ("PRE8_6" ((r+1)*8-1)/64) ("PRE5_3" mod(((r+1)*8-1)/8 8)) )
       p1 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "IWLD8%d" R/8-1) sprintf(nil "%s<%d>" pre preNum) 1)
       net = dbMakeNet(cvid sprintf(nil "%s<%d>" pre preNum))

       for(i 0 7

        ; Find location of A/B<> pin to connect PRE<> to and drop appropriate via
        ; M2-M1 for A/B<even> and M3-M2 for A/B<odd> for st65 at the intersection of p1 and p2
	ab = case(pre ("PRE8_6" "B") ("PRE5_3" "A"))
        p2 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "IWLD8%d" r) sprintf(nil "%s<%d>" ab i) 1)
        loc = xCoord(p1):yCoord(p2)
	viaName = case(modulo(i,2) (0 lowMetalVia) (t highMetalVia))
        UvaEceLayoutCreateViaArray(cvid viaLibName viaName loc net ?rotation "R90")
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

let((libName cellName tapPitch R C)
  R=128
  C=16
  tapPitch=32 ;meaning a well-tap every 32 rows
  libName="highTempSRAM"
  wldCellName = "WLDriver8_NC16"
  tapName = "WLDriverNC16_tap"
  topFillerName = sprintf(nil "WLDRIVER_FILLER%d" R)
  botFillerName = sprintf(nil "WLDRIVER_BOT_FILLER%d" R)
  viaLibName="cmos065"
  sprintf(cellName "WLDRIVERDMM_%d" R)
  UvaEceCreateWLDriverLayout(libName cellName wldCellName topFillerName botFillerName tapName R tapPitch) 
)
