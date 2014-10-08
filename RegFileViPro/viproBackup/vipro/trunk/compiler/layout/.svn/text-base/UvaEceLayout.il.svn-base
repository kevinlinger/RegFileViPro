; SKILL scripts for handling layout
; Need to include UvaEceMath.il - assume that the local ckeckout dir is 
; ./SKILL_Lib  relative to the dir where you run icfb
load("UvaEceMath.il")

; DEFINE GLOBAL VARIABLES
UvaEceBBoxLayerName = "PRBOUNDARY"	; name of the layer used for layout bounding boxes - use all caps

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   
;;;    LIST OF PROCEDURES IN THIS FILE
;;;   
;;;   UvaEceDeleteObjectsLayout(cvid)
;;;   UvaEceLayoutFindInstBboxByName(cvid instName)
;;;   UvaEceLayoutCreateInst(cvid libName cellName cellType instName origin rotation UvaEceBBoxLayerName)
;;;   UvaEceLayoutListAllPins(cvid instName)
;;;   UvaEceLayoutFindInstPinCenter(cvid instName pinName pinNumber) 
;;;   UvaEceLayoutFindInstPinBbox(cvid instName pinName pinNumber) 
;;;   UvaEceLayoutCreateNewInstPinSamePlace(cvid instName pinName pinNumber net label fontsize) 
;;;   UvaEceLayoutCreatePin(cvid layerName bBox netInst netName pinType pinInstName)
;;;   UvaEceLayoutCreatePinAndLabel(cvid layerName bBox netInst pinInstName)
;;;   UvaEceBoxDimensions(cvid instName)
;;;   UvaEceGetBboxDimensions(cvid bBox)
;;;   UvaEceGetBboxDimensions(bBox)
;;;   UvaEceGetBboxCenter(bBox)
;;;   UvaEceMoveInstByName(cvid instName newxy)
;;;   UvaEceMoveInstRelativeByName(cvid instName xyrel)
;;;   UvaEceAlignInstTopWithBox(cvid instName bBox)
;;;   UvaEceSnapToGrid(pt)
;;;   UvaEceLayoutCreateViaArray(cvid libname cellname location center_LLbar rows cols xpitch ypitch width net)
;;;   UvaEceLayoutFindAllPinNames(cvid instName)
;;;   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

procedure( UvaEceDeleteObjectsLayout(cvid)
  prog((propName inst)
    dbDeleteAllNet(cvid)
    foreach(inst cvid~>instances
      dbDeleteObject(inst)
    )
    foreach(inst cvid~>shapes
      dbDeleteObject(inst)
    )
  return(t)
  )
)

procedure(  UvaEceLayoutFindInstBboxByName(cvid instName)
  prog((mstr inst origin rotation lppList bBoxMaster ur ll originR ur1 originRx originRy ur1x ur1y bBox)

    inst = dbFindAnyInstByName(cvid instName)
    if(inst==nil then 
	printf("UvaEceLayoutFindInstBboxByName: Instance %s not found in this cellview.\n" instName)
    )
    mstr = inst~>master
    origin = inst~>xy
    rotation = inst~>orient

    lppList = mstr~>layerPurposePairs
    foreach(lpp lppList
	lppName = upperCase(lpp~>layerName)
	if( lppName == UvaEceBBoxLayerName then
	  bBoxMaster = car(lpp~>shapes)~>bBox
	)
      )
    ur = UvaEceGetBboxCorners( bBoxMaster "upperRight")
    ll = UvaEceGetBboxCorners( bBoxMaster "lowerLeft")

    if( rotation == "R0" then
      originR = xCoord(origin)+xCoord(ll):yCoord(origin)+yCoord(ll)
      ur1 = xCoord(origin)+xCoord(ur) : yCoord(origin)+yCoord(ur)
    )
    if( rotation == "R90" then
      originRx = xCoord(origin)-xCoord(ur)
      originRy = yCoord(ur)
      originR = originRx:originRy
      ur1x = xCoord(origin)
      ur1y = yCoord(ur) + yCoord(origin)
      ur1 = ur1x:ur1y
    )
    if( rotation == "R180" then
      originRx = xCoord(origin)-xCoord(ur)
      originRy = yCoord(origin)-yCoord(ur)
      originR = originRx:originRy
      ur1x = xCoord(origin)+xCoord(ll)
      ur1y = yCoord(origin)+yCoord(ll) 
      ur1 = ur1x:ur1y
    )
    if( rotation == "R270" then
      originRx = xCoord(origin)
      originRy = yCoord(origin)-yCoord(ur)
      originR = originRx:originRy
      ur1x = xCoord(origin)+xCoord(ur)
      ur1y = yCoord(origin)
      ur1 = ur1x:ur1y
    )
    if( rotation == "MX" then
      originRx = xCoord(origin)+xCoord(ll)
      originRy = yCoord(origin)-yCoord(ur)
      originR = originRx:originRy
      ur1x = xCoord(origin)+xCoord(ur)
      ur1y = yCoord(origin)-yCoord(ll)
      ur1 = ur1x:ur1y
    )
    if( rotation == "MY" then
      originRx = xCoord(origin)-xCoord(ur)
      originRy = yCoord(origin)+yCoord(ll)
      originR = originRx:originRy
      ur1x = xCoord(origin)-xCoord(ll)
      ur1y = yCoord(origin)+yCoord(ur)
      ur1 = ur1x:ur1y
    )

    bBox = list(originR ur1)      
    return(bBox)


  )
)


procedure( UvaEceLayoutCreateInst(cvid libName cellName cellType instName origin rotation UvaEceBBoxLayerName)
  prog((mstr inst bBox bBoxMaster lppList lpp x0 y0 x1 y1 originR)
    mstr = dbOpenCellViewByType(libName cellName cellType)
    if(mstr==nil then 
	printf("UvaEceLayoutCreateInst: Cell %s in library %s not found.\n" cellName libName)
	return(list(-1:-1 -2:-2))
    )

    lppList = mstr~>layerPurposePairs

    foreach(lpp lppList
	lppName = upperCase(lpp~>layerName)
	if( lppName == UvaEceBBoxLayerName then
	  bBoxMaster = car(lpp~>shapes)~>bBox
	)
      )

    if(bBoxMaster==nil then
	printf("ERROR in UvaEceLayoutCreateInst:\n")
	printf("      Cell %L does not have a %L bBox\n" cellName UvaEceBBoxLayerName)
    )
    ur = UvaEceGetBboxCorners( bBoxMaster "upperRight")
    ll = UvaEceGetBboxCorners( bBoxMaster "lowerLeft")    
    lr = UvaEceGetBboxCorners( bBoxMaster "lowerRight")    

    if( rotation == "R0" then
      org = xCoord(origin)-xCoord(ll):yCoord(origin)-yCoord(ll)
      originR = org
      ur1 = xCoord(org)+xCoord(ur) : yCoord(org)+yCoord(ur)
    )
    if( rotation == "R90" then
      originRx = xCoord(origin)+yCoord(ur)
      originRy = yCoord(origin)
      originR = originRx:originRy
      ur1 = xCoord(origin)+yCoord(ur) : yCoord(origin)+xCoord(ur)
    )
    if( rotation == "R180" then
      originRx = xCoord(ur)+xCoord(origin)
      originRy = yCoord(ur)+yCoord(origin)
      originR = originRx:originRy
      ur1 = originR
    )
    if( rotation == "R270" then
      originRx = xCoord(origin)
      originRy = yCoord(origin)+xCoord(ur)
      originR = originRx:originRy
      ur1 = xCoord(origin)+yCoord(ur) : yCoord(origin)+xCoord(ur)
    )
    if( rotation == "MX" then
      originRx = xCoord(origin)-xCoord(ll)
      originRy = yCoord(origin)+yCoord(ur)
      originR = originRx:originRy
      ur1 = xCoord(origin)+xCoord(ur): yCoord(origin)+yCoord(ur)
    )
    if( rotation == "MY" then
      originRx = xCoord(origin)+xCoord(ur)
      originRy = yCoord(origin)-yCoord(lr)
      originR = originRx:originRy
      ur1 = originRx-xCoord(ll): originRy+yCoord(ur)
    )

    inst = dbCreateInst(cvid mstr instName originR rotation 1)

    bBox = list(origin ur1)      

    return(bBox)
  )
)

procedure( UvaEceLayoutListAllPins(cvid instName)
  prog( (inst rects pN bBox layerName att)

  inst = dbFindAnyInstByName(cvid instName)
    if(inst==nil then 
	printf(" UvaEceLayoutListAllPins: Instance %s not found in this cellview.\n" instName)
    )

  foreach(rects inst~>master~>lpps
      if(rects~>purpose == "pin" then
      foreach(shapes  rects~>shapes
        pN = shapes~>net~>name
	bBox = shapes~>bBox
	layerName = shapes~>layerName
        att = list(pN bBox layerName)
	println(att)
        )
      )
    )

))

procedure( UvaEceLayoutFindInstPinCenter(cvid instName pinName pinNumber) 
  prog( (inst rects shapes bBoxX bBoxY xy0 xy1 xy origin rotation deltax deltay bBoxorig)
  
  inst = dbFindAnyInstByName(cvid instName)
    if(inst==nil then 
	printf(" UvaEceLayoutFindInstPinCenter: Instance %s not found in this cellview.\n" instName)
    )

  index = 1
  bBoxOrig = nil
  foreach(rects inst~>master~>lpps

    if(rects~>purpose == "pin" then
      foreach(shapes  rects~>shapes
        pN = shapes~>net~>name
	;;if(pN==nil then pN=shapes~>theLabel)
        if( pN == pinName then
          if( index == pinNumber then      
          bBoxOrig = shapes~>bBox
          )
          index = index + 1
	))))
  if(bBoxOrig==nil then
    printf("ERROR in UvaEceLayoutFindInstPinCenter:\n")
    printf("  Cannot find pin %L in cell %L\n" pinName instName)
  )
  ; Get the origin
  xy0 = UvaEceGetBboxCorners( bBoxOrig "lowerLeft")
  xy1 = UvaEceGetBboxCorners( bBoxOrig "upperRight")
  deltax = (xCoord(xy1)-xCoord(xy0))/2
  deltay = (yCoord(xy1)-yCoord(xy0))/2
  origin = inst~>xy
  rotation = inst~>orient  

    if( rotation == "R0" then
      bBoxX = xCoord(xy0)+deltax+xCoord(origin)
      bBoxY = yCoord(xy0)+deltay+yCoord(origin)
    )
    if( rotation == "R180" then
      bBoxX = xCoord(origin)-xCoord(xy0)-deltax
      bBoxY = yCoord(origin)-yCoord(xy0)-deltay
    )
    if( rotation == "MX" then
      bBoxX = xCoord(origin)+xCoord(xy0)+deltax
      bBoxY = yCoord(origin)-yCoord(xy0)-deltay
    )
    if( rotation == "MY" then
      bBoxX = xCoord(origin)-xCoord(xy0)-deltax
      bBoxY = yCoord(origin)+yCoord(xy0)+deltay
    )
    if( rotation == "R270" then
      bBoxX = xCoord(origin)+yCoord(xy0)+deltay
      bBoxY = yCoord(origin)-xCoord(xy0)-deltax
    )
    if( rotation == "R90" then  ;; ADDED 2-25-05 BHC
      bBoxX = xCoord(origin)-yCoord(xy1)+deltay
      bBoxY = yCoord(origin)+xCoord(xy0)+deltax
    )

  xy = bBoxX:bBoxY
  return(xy)
  )
)

procedure( UvaEceLayoutFindInstPinBbox(cvid instName pinName pinNumber) 
  prog( (inst index bBoxOrig rects shapes pN xy xy0 xy1 x y bBox rotation)
  
  ; ASSUMES NO ROTATION

  inst = dbFindAnyInstByName(cvid instName)

  index = 1
  bBoxOrig = nil
  foreach(rects inst~>master~>lpps

    if(rects~>purpose == "pin" then
      foreach(shapes  rects~>shapes
        pN = shapes~>net~>name
	;;if(pN==nil then pN=shapes~>theLabel)
        if( pN == pinName then
          if( index == pinNumber then 
          bBoxOrig = shapes~>bBox
          )
          index = index + 1
	))))

  if(bBoxOrig==nil then 
    printf("ERROR - Cannot find pin %s in instance %s.\n" pinName instName)
  )

  xy = inst~>xy
  rotation=inst~>orient
  ; default (R0)  
   xy0 = UvaEceAddCoords(xy car(bBoxOrig))
   xy1 = UvaEceAddCoords(xy cadr(bBoxOrig))

  if( rotation == "MY" then 
   bBox = UvaEceLayoutFindInstBboxByName(cvid instName)
   x = car(cadr(bBox))-car(cadr(bBoxOrig))
   y = yCoord(xy)+cadr(car(bBoxOrig))
   xy0 = x:y
   x = car(cadr(bBox))-car(car(bBoxOrig))
   y = yCoord(xy)+cadr(cadr(bBoxOrig))
   xy1 = x:y   
  )

  if( rotation == "MX" then 
   ;;bBox = UvaEceLayoutFindInstBboxByName(cvid instName)
   x = xCoord(xy)+car(car(bBoxOrig))
   y = yCoord(xy)-cadr(car(bBoxOrig))
   xy0 = x:y
   x = xCoord(xy)+car(cadr(bBoxOrig))
   y = yCoord(xy)-cadr(cadr(bBoxOrig))
   xy1 = x:y   
  )

  if( rotation == "R180" then 
   bBox = UvaEceLayoutFindInstBboxByName(cvid instName)
   x = car(cadr(bBox))-car(cadr(bBoxOrig))
   y = cadr(cadr(bBox))-cadr(cadr(bBoxOrig))
   xy0 = x:y
   x = car(cadr(bBox))-car(car(bBoxOrig))
   y = cadr(cadr(bBox))-cadr(car(bBoxOrig))
   xy1 = x:y   
  )

  if( rotation == "R270" then  
   x = car(xy)+cadr(car(bBoxOrig))
   y = cadr(xy)-car(car(bBoxOrig))
   xy0 = x:y
   x = car(xy)+cadr(cadr(bBoxOrig))
   y = cadr(xy)-car(cadr(bBoxOrig))
   xy1 = x:y   
  )

  bBox = list(xy0 xy1)    

  return(bBox)
))

procedure( UvaEceLayoutCreateNewInstPinSamePlace(cvid instName pinName pinNumber net label fontsize) 
  prog( (inst index bBoxOrig rects mylabel shapes pN xy xy0 xy1 x y bBox rotation layer)
  
  inst = dbFindAnyInstByName(cvid instName)
  if(inst==nil then
	printf("UvaEceLayoutCreateNewInstPinSamePlace: Instance %s not found.\n" instName)
  )

  index = 1
  bBoxOrig = nil
  foreach(rects inst~>master~>lpps

    if(rects~>purpose == "pin" then
      foreach(shapes  rects~>shapes
        pN = shapes~>net~>name
         if(pN==nil then pN=shapes~>theLabel)
	if(pN==nil then printf("UvaEceLayoutCreateNewInstPinSamePlace: Problem recognizing labels.\n"))
        if( pN == pinName then
          if( index == pinNumber then 
	  layer = car(shapes~>lpp)
          bBoxOrig = shapes~>bBox
          )
          index = index + 1
	))))
  xy = inst~>xy
  rotation=inst~>orient
  if(bBoxOrig==nil then
	printf("UvaEceLayoutCreateNewInstPinSamePlace: Pin %s not found in %s.\n" pinName instName)
  )
  ; default (R0)  
   xy0 = UvaEceAddCoords(xy car(bBoxOrig))
   xy1 = UvaEceAddCoords(xy cadr(bBoxOrig))

  if( rotation == "MY" then 
   bBox = UvaEceLayoutFindInstBboxByName(cvid instName)
   x = car(cadr(bBox))-car(cadr(bBoxOrig))
   y = yCoord(xy)+cadr(car(bBoxOrig))
   xy0 = x:y
   x = car(cadr(bBox))-car(car(bBoxOrig))
   y = yCoord(xy)+cadr(cadr(bBoxOrig))
   xy1 = x:y   
  )

  if( rotation == "MX" then 
   ;;bBox = UvaEceLayoutFindInstBboxByName(cvid instName)
   x = xCoord(xy)+car(car(bBoxOrig))
   y = yCoord(xy)-cadr(car(bBoxOrig))
   xy0 = x:y
   x = xCoord(xy)+car(cadr(bBoxOrig))
   y = yCoord(xy)-cadr(cadr(bBoxOrig))
   xy1 = x:y   
  )

  if( rotation == "R180" then 
   bBox = UvaEceLayoutFindInstBboxByName(cvid instName)
   x = car(cadr(bBox))-car(cadr(bBoxOrig))
   y = cadr(cadr(bBox))-cadr(cadr(bBoxOrig))
   xy0 = x:y
   x = car(cadr(bBox))-car(car(bBoxOrig))
   y = cadr(cadr(bBox))-cadr(car(bBoxOrig))
   xy1 = x:y   
  )

  if( rotation == "R270" then  
   x = car(xy)+cadr(car(bBoxOrig))
   y = cadr(xy)-car(car(bBoxOrig))
   xy0 = x:y
   x = car(xy)+cadr(cadr(bBoxOrig))
   y = cadr(xy)-car(cadr(bBoxOrig))
   xy1 = x:y   
  )

  bBox = list(xy0 xy1)    
  rectPin = dbCreateRect(cvid list(layer "pin") bBox)
  pinInst = dbCreatePin(net rectPin nil)
;  x = xCoord(UvaEceGetBboxDimensions(cvid bBox))/2.0
;  y = yCoord(UvaEceGetBboxDimensions(cvid bBox))/2.0
  x = xCoord(UvaEceGetBboxDimensions(bBox))/2.0
  y = yCoord(UvaEceGetBboxDimensions(bBox))/2.0
  p1 = UvaEceAddCoords(car(bBox) x:y)
  p1 = UvaEceSnapToGrid(p1)
  mylabel = dbCreateLabel(cvid list(layer "pin") p1 label "centerCenter" "R0" "roman" fontsize)
  return(pinInst)
))

procedure( UvaEceLayoutCreatePin(cvid layerName bBox netInst netName pinType pinInstName)
  prog((rectPin pinInst)

    rectPin = dbCreateRect(cvid list(layerName "pin") bBox)
    pinInst = dbCreatePin(netInst rectPin pinInstName)

  return(pinInst)
  )
)

procedure( UvaEceLayoutCreatePinAndLabel(cvid layerName bBox netInst pinInstName)
  prog((rectPin pinInst center w h labelLoc dim)

    rectPin = dbCreateRect(cvid list(layerName "pin") bBox)
    pinInst = dbCreatePin(netInst rectPin pinInstName)
    dim = UvaEceGetBboxDimensions(bBox)
    w = abs(car(dim))
    h = abs(cadr(dim))
    if( w<h then
      labelHeight = w
    else 
      labelHeight = h
    )
    labelLoc = UvaEceGetBboxCorners(bBox "upperLeft")
    dbCreateLabel(cvid list(layerName "pin") labelLoc netInst~>name "centerCenter" "R0" "roman" labelHeight)

  return(pinInst)
  )
)

procedure( UvaEceBoxDimensions(cvid instName)
  prog((bBox ul lr h w)
    bBox = UvaEceLayoutFindInstBboxByName(cvid instName)
    ul = UvaEceGetBboxCorners(bBox "upperLeft")
    lr = UvaEceGetBboxCorners(bBox "lowerRight")
    h = yCoord(ul)-yCoord(lr)
    w = xCoord(lr)-xCoord(ul)
    return(list(w h))
))

;; Changed to exclude cvid on 10-20-04
;;procedure( UvaEceGetBboxDimensions(cvid bBox)
procedure( UvaEceGetBboxDimensions(bBox)
  prog((ul lr h w)
    ul = UvaEceGetBboxCorners(bBox "upperLeft")
    lr = UvaEceGetBboxCorners(bBox "lowerRight")
    h = yCoord(ul)-yCoord(lr)
    w = xCoord(lr)-xCoord(ul)
    return(list(w h))
))

;; Added 11-23-04
procedure( UvaEceGetBboxCenter(bBox)
  prog((ul lr h w x y)
    ul = UvaEceGetBboxCorners(bBox "upperLeft")
    lr = UvaEceGetBboxCorners(bBox "lowerRight")
    h = yCoord(ul)-yCoord(lr)
    w = xCoord(lr)-xCoord(ul)
    x = w/2.0
    y = h/2.0
    return(list(x y))
))

procedure( UvaEceMoveInstByName(cvid instName newxy)
  prog((inst)
    inst=dbFindAnyInstByName(cvid instName)
    inst~>xy=newxy         
    return(t)
))

procedure( UvaEceMoveInstRelativeByName(cvid instName xyrel)
  prog((inst xy)
    inst=dbFindAnyInstByName(cvid instName)
    xy=inst~>xy
    xy=xCoord(xy)+xCoord(xyrel):yCoord(xy)+yCoord(xyrel)
    inst~>xy=xy         
    return(t)
))

procedure( UvaEceAlignInstTopWithBox(cvid instName bBox)
  prog((wh xy)
    wh = UvaEceBoxDimensions(cvid instName)
    xy = UvaEceGetBboxCorners(bBox "upperRight")
    xy = xCoord(xy):yCoord(xy)-yCoord(wh)
    UvaEceMoveInstByName(cvid instName xy)
    return(t)
))
  
procedure( UvaEceSnapToGrid(pt)  ;; SNAP TO NEAREST 100th of a uM
  prog((x y newpt)
    x=xCoord(pt)
    y=yCoord(pt)
    x=round(100.0*x)/100.0
    y=round(100.0*y)/100.0
    newpt=x:y
    return(newpt)
))

;; CREATE an array of via contacts (p-cell that includes the via and the connecting metals) in layout
;;old definition - procedure( UvaEceLayoutCreateViaArray(cvid libname cellname location center_LLbar rows cols xpitch ypitch width net @optional (rotation "R0")) - make more arguments optional

procedure( UvaEceLayoutCreateViaArray(cvid libname cellname location net @key (viaViewName "layout") (center_LLbar 1) (rows 1) (cols 1) (xpitch 0.17) (ypitch 0.17) (width 0.1) (rotation "R0"))
  prog((inst xy bBox)
 ;;;  INPUTS  ;;;;;;;;;;;;;;;;;;;;;;
 ;; cvid - 		the cellview
 ;; libname - 		library with the vias in it
 ;; cellname - 		name of the via
 ;; location - 		point to locate the via array
 ;; center_LLbar - 	1 - location is the center; 0 - location is the lowerleft corner of the via array
 ;; rows - 		num of rows
 ;; cols - 		num of cols
 ;; xpitch - 		xpitch of cols
 ;; ypitch - 		ypitch of rows
 ;; viaViewName -	usually "symbolic", sometimes "layout"
 ;; width -
 ;; net - 		net connected to the vias
 ;; rotation - 		rotation of the vias
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   inst = dbCreateInstByMasterName(cvid libname cellname viaViewName nil location rotation)
    if(inst != nil then
	if(rows > 1 then
	   dbCreateProp(inst "row" "int" rows))
	if(cols > 1 then
	   dbCreateProp(inst "column" "int" cols))
	if(xpitch != nil then
	   dbCreateProp(inst "xPitch" "float" xpitch))
	if(ypitch != nil then
	   dbCreateProp(inst "yPitch" "float" ypitch))
	if(width != nil then
	   dbCreateProp(inst "w" "float" width)
	   dbCreateProp(inst "l" "float" width))
	if(net != nil then 
	   inst~>net = net)
	if(center_LLbar == 0 then
	   xy=location
	   bBox=inst~>bBox
	   xyrel=(caadr(bBox)-caar(bBox))/2:(yCoord(cadr(bBox))-yCoord(car(bBox)))/2
	   xy=xCoord(xy)+xCoord(xyrel):yCoord(xy)+yCoord(xyrel)
           inst~>xy=xy         
	)
    ) 
    return(inst)
))

procedure( UvaEceLayoutFindAllPinNames(cvid instName)
  prog( (inst rects pN bBox layerName att)

  inst = dbFindAnyInstByName(cvid instName)

  names = list()

  foreach(rects inst~>master~>lpps
      if(rects~>purpose == "pin" then
      foreach(shapes  rects~>shapes
        pN = shapes~>net~>name
	bBox = shapes~>bBox
	layerName = shapes~>layerName
	if( pN then
          names = cons(pN names)
	  )
        )
      )
    )
  println(names)
  return(names)  
))

