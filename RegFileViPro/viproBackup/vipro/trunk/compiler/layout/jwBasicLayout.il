/* This procedure creates the additional functions for Layout 
in FSL65/ST65

*/

load("UvaEceLayout.il")

;; bBox Layer Name    
UvaEceBBoxLayerName = "PRBOUNDARY";
UvaEcebBoxLayerType = "drawing";

;; For creating rectangle, it needs exact case - jwLayoutCreateBbox function
bBoxLayerName = "prBoundary";
bBoxLayerType = "drawing";

;; M1 min-W min-S
M1 = "M1"
M1_mW = 0.25
M1_mS = 0.3
M1_pitch = 0.6

;; M2 min-W min-S
M2 = "M2"
M2_mW = 0.25
M2_mS = 0.3
M2_pitch = 0.6

;; M3 min-W min-S
M3 = "M3"
M3_mW = 0.25
M3_mS = 0.3

;; V12 pitch
V12 = "VIA12"
V12_p = 0.7

;; V23 pitch
V23 = "VIA23"
V23_p = 0.7

procedure( jwLayoutCreateViaArray(cvid libname cellname location orient rows cols xpitch ypitch MBname MTname)
  prog((inst xy bBox po)
    masterView =dbOpenCellViewByType(libname cellname "symbolic")
    ;; Recompute the center 
    loc = xCoord(location)-xpitch*(cols-1)/2 : yCoord(location)-ypitch*(rows-1)/2 
    inst=dbCreateSimpleMosaic(cvid masterView nil loc orient rows cols xpitch ypitch)

    ;; Create Metal surrounding the vias
    ;; NOTE: hardcode metal width
    ;; 0.15: extention of Metal from Via
    ;po = UvaEceAddCoords(location -0.45-xpitch*(cols-1)/2:-0.45-ypitch*(rows-1)/2)
    ;My = 0.45*2+ypitch*(rows-1)
    ;Mx = 0.45*2+xpitch*(cols-1)
    po = UvaEceAddCoords(location -0.3-xpitch*(cols-1)/2:-0.3-ypitch*(rows-1)/2)
    My = 0.3*2+ypitch*(rows-1)
    Mx = 0.3*2+xpitch*(cols-1)
    dbCreateRect(cvid list(MBname "drawing") list(po UvaEceAddCoords(po Mx:My))) 
    dbCreateRect(cvid list(MTname "drawing") list(po UvaEceAddCoords(po Mx:My))) 
    return(inst)
))

;; CREATE HANDLE LABEL
procedure( jwLayoutCreateHandle(cvid location)
  prog((layerName labelHeight)
    layerName="PORTHANDLE"
    labelHeight=1
    dbCreateLabel(cvid list(layerName "drawing") location "handle!" "centerCenter" "R0" "roman" labelHeight)
    return(t)
))


;; CREATE BOUNDARY BOX 
procedure( jwLayoutCreateBbox(cvid bBox)
  prog(()
    dbCreateRect(cvid list(bBoxLayerName bBoxLayerType) bBox)
    return(t)
))

;; CREATE VIA12
procedure( jwLayoutCreateVia12Array(cvid location rows cols)
  prog((v12_p)
    if( rows<5 && cols<5 then
        v12_p = 0.7 
    else 
       if( rows*cols<24 then
        v12_p = 0.8
       else
        v12_p = 1.05
       )
    )
    jwLayoutCreateViaArray(cvid "NCSU_3DIC_LL018" V12 location "R0" rows cols v12_p v12_p M1 M2)
    return(t)
))

;; CREATE VIA23
procedure( jwLayoutCreateVia23Array(cvid location rows cols)
  prog((v23_p)
    if( rows<5 && cols<5 then
        v23_p = 0.7 
    else 
       if( rows*cols<24 then
        v23_p = 0.8
       else
        v23_p = 1.05
       )
    )
    jwLayoutCreateViaArray(cvid "NCSU_3DIC_LL018" V23 location "R0" rows cols v23_p v23_p M2 M3)
    return(t)
))


;; CREATE VIA13
procedure( jwLayoutCreateVia13Array(cvid location rows cols)
  prog((v12_p v23_p)
    if( rows<5 && cols<5 then
        v12_p = 0.7 
        v23_p = 0.7 
    else 
       if( rows*cols<24 then
        v12_p = 0.8
        v23_p = 0.8
       else
        v12_p = 1.05
        v23_p = 1.05
       )
    )
    jwLayoutCreateViaArray(cvid "NCSU_3DIC_LL018" V12 location "R0" rows cols v12_p v12_p M1 M2)
    jwLayoutCreateViaArray(cvid "NCSU_3DIC_LL018" V23 location "R0" rows cols v23_p v23_p M2 M3)
    return(t)
))

;; TILE CELLS
procedure( svnTileCells(cvid libname cellName instName numInstances location @key (rotation "R0") (bBoxLayerName "PRBOUNDARY") (offset 0) (nextOrigin "upperLeft"))
  prog((i bBox xy)
   
   xy = location

   if(numInstances !=1 then
    for(i 0 numInstances-1
	bBox = UvaEceLayoutCreateInst(cvid libName cellName "layout" sprintf(nil "%s%d" instName i) xy rotation bBoxLayerName)
	xy = UvaEceGetBboxCorners(bBox,"lowerRight")
	xy = xCoord(xy)+offset:yCoord(xy)
    )
   else
    bBox = UvaEceLayoutCreateInst(cvid libName cellName "layout" instName xy rotation bBoxLayerName)
    xy = UvaEceGetBboxCorners(bBox,"lowerRight")
   )
   xy = UvaEceGetBboxCorners(bBox,nextOrigin) 
  return(xy)
))

;; CREATE TOP LEVEL PINS
procedure( svnCreatePins(cvid pinName sigName instName pinMetal @key (bus t) (busWidth 1) (busOffset 0) (instOffset 0) (pinOffset 0))
  prog((i net p1)

  case(bus
    ("multiInst" 
     for(i 0 busWidth-1
	net = dbMakeNet(cvid sprintf(nil "%s<%d>" sigName i+busOffset))
	p1 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "%s%d" instName i+instOffset) pinName 1)
 	UvaEceLayoutCreatePinAndLabel(cvid pinMetal list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "%s<%d>" sigName i+busOffset))
    )
   )

   ("sameInst"
    for(i 0 busWidth-1
	net = dbMakeNet(cvid sprintf(nil "%s<%d>" sigName i+busOffset))
	p1 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "%s" instName) sprintf(nil "%s<%d>" pinName i) 1)
	UvaEceLayoutCreatePinAndLabel(cvid pinMetal list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sprintf(nil "%s<%d>" sigName i+busOffset))
    )
   )

   (t
    net = dbMakeNet(cvid sigName)
    p1 = UvaEceLayoutFindInstPinCenter(cvid sprintf(nil "%s" instName) pinName 1)
    UvaEceLayoutCreatePinAndLabel(cvid pinMetal list(UvaEceAddCoords(p1 -0.02:-0.02) UvaEceAddCoords(p1 0.02:0.02)) net sigName)
   )
 )
return(t)
))
