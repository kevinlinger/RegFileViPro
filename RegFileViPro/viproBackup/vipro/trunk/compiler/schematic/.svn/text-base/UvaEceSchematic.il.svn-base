; SKILL scripts for handling layout
load("./skill/UvaEceMath.il")

procedure( UvaEceDeleteObjectsSchematic(cvid)
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

procedure( UvaEceSymbolCreatePin(cvid pinName pinType origin rotation)
  prog((pin net term xy0 xy1 labelPlace rect Label)
    
   /* First create a net, then a terminal, then the pin shape */
   xy0 = xCoord(origin)-.025:yCoord(origin)-.025
   xy1 = xCoord(origin)+.025:yCoord(origin)+.025
   if( pinType == "output" then
     labelPlace = xCoord(origin)-.1:yCoord(origin)
     labelOrient = "centerRight"
   else
     labelPlace = xCoord(origin)+.1:yCoord(origin)
     labelOrient = "centerLeft")
  
   Label = dbCreateLabel(cvid list(229 237) labelPlace pinName 
     labelOrient "R0" "stick" 6.250000e-02)
   rect = dbCreateRect(cvid list(229 252) list(xy0 xy1))
   net = dbCreateNet(cvid pinName nil)
   term = dbCreateTerm(net pinName pinType)
   pin = dbCreatePin(net rect nil)

   Label~>parent = rect

  return(pin)
  )
)

procedure( UvaEceSchematicCreatePin(cvid pinName pinType origin rotation)
  prog((pin net term inst mstr pinCV xy newxy x y stretchxy xyoffset)
    
   /* First create a net, then a terminal, then the pin shape */

   pinCV = case( pinType
      ("input" "ipin")
      ("output" "opin")
      ("inputOutput" "iopin"))
   mstr = dbOpenCellViewByType("basic" pinCV "symbol")
   inst = dbCreateInst(cvid mstr nil origin rotation 1)
   inst~>purpose = "pin"

   net = dbCreateNet(cvid pinName nil)
if(net==nil then net=dbMakeNet(cvid pinName))
     term = dbCreateTerm(net pinName pinType)
   pin = dbCreatePin(net inst)
   xy = UvaEceGetPinCenter(inst)
   xyoffset = case( pinType
      ("input" .125:0.0625)
      ("output" -.125:0.0625)
      ("inputOutput" -0.0625:-0.095))
   xy=UvaEceAddCoords(xy xyoffset)
   x = xCoord(xy)
   y = yCoord(xy)
   stretchxy = case(rotation
	 ("R0" (x-.2):y)
	 ("R180" (x+.2):y)
	 ("R90" x:(y+.2))
	 ("R270" x:(y-.2))
   )
   line = dbCreateLine(cvid list(228 252) list(xy stretchxy))~>net=net
   return(pin)
  )
)

procedure( UvaEceSchematicCreateInst(cvid libName cellName cellType instName leftPins rightPins topPins botPins origin rotation)
  prog((inst mstr bBox d)

    mstr = dbOpenCellViewByType(libName cellName cellType)
    inst = dbCreateInst(cvid mstr instName origin rotation 1)
inst2=inst
   /* Now add the connectivity */

    UvaEceAddLabelsToInstPins(cvid inst origin mstr leftPins "left")        
    UvaEceAddLabelsToInstPins(cvid inst origin mstr  rightPins "right")        
    UvaEceAddLabelsToInstPins(cvid inst origin mstr  topPins "top")        
    UvaEceAddLabelsToInstPins(cvid inst origin mstr   botPins "bottom")        


  return(inst)
  )
)

procedure( UvaEceAddLabelsToInstPins(cvid inst origin mstr pinList side)
  prog( (pinPair shape instPinName pinLabel x y newxy stretchxy rotation label line)

      rotation = case(side
        ("left" "R0")
        ("right" "R0")
        ("top" "R90")
        ("bottom" "R270")
      )

    foreach(pinPair pinList
      instPinName = car(pinPair)
      pinLabel = car(last(pinPair))

      net = dbMakeNet(cvid pinLabel nil)
      dbCreateConnByName(net inst instPinName)
      xy = UvaEceGetPinCenterByName(mstr instPinName)
      newxy = UvaEceAddCoords(xy origin)

      x = xCoord(newxy)
      y = yCoord(newxy)
      stretchxy = case(side
        ("left" (x-.2):y)
        ("right" (x+.2):y)
        ("top" x:(y+.2))
        ("bottom" x:(y-.2))
      )

      line = dbCreateLine(cvid list(228 252) list(newxy stretchxy))~>net=net

      label = dbCreateLabel(cvid list(228 237) stretchxy pinLabel "lowerCenter" rotation "stick" 6.250000e-02)
      label~>isDrafted = t
      label~>isOverbar = nil
      label~>isVisible = t
      label~>labelType = "normalLabel"
    )
        

  return(t)
  )
)

procedure( UvaEceGetPinCenterByName(inst instPinName)
  prog( (x y shape xy bBox x1 x2 y1 y2)
    foreach(shape inst~>shapes
      if( shape~>layerName=="pin" then
;;printf("%L \n" shape~>children~>theLabel)
        if( car(shape~>children~>theLabel)==instPinName then
          bBox = shape~>bBox
        )
        if( car(cdr(shape~>children~>theLabel))==instPinName then
          bBox = shape~>bBox
        )
      )
    )
  if(bBox==nil then
     printf("ERROR - pin %L not found in instance type %L\n" instPinName inst~>cellName)
     return(0)
  )
  x1 = xCoord(car(bBox))
  x2 = xCoord(car(last(bBox)))
  x  = (x1 + x2)/2
  
  y1 = yCoord(car(bBox))
  y2 = yCoord(car(last(bBox)))
  y  = (y1 + y2)/2
  xy = x:y

  return(xy)
  )
)

procedure( UvaEceGetPinCenter(inst)
  prog((bBox x1 x2 x y1 y2 xy)
 	bBox = inst~>bBox	
        x1 = xCoord(car(bBox))
        x2 = xCoord(car(last(bBox)))
        x  = (x1 + x2)/2
        
        y1 = yCoord(car(bBox))
        y2 = yCoord(car(last(bBox)))
        y  = (y1 + y2)/2
        xy = x:y
        return(xy)
  )
)
procedure( UvaEceSchematicCreateFETInstDefault(cvid libName cellName cellType instName leftPins rightPins topPins botPins origin rotation)
  prog((inst mstr bBox d)

    mstr = dbOpenCellViewByType(libName cellName cellType)
    inst = dbCreateInst(cvid mstr instName origin rotation 1)

   /* Now add the connectivity */

    UvaEceFETAddLabelsToInstPins(cvid inst origin mstr leftPins "left")        
    UvaEceFETAddLabelsToInstPins(cvid inst origin mstr  rightPins "right")        
    UvaEceFETAddLabelsToInstPins(cvid inst origin mstr  topPins "top")        
    UvaEceFETAddLabelsToInstPins(cvid inst origin mstr   botPins "bottom")        

  return(inst)
  )
)
procedure( UvaEceSchematicCreateFETInst(cvid libName cellName cellType instName leftPins rightPins topPins botPins origin rotation wFinger Length Bconn mi miX @optional (SUBPmos "VSS"))
  prog((inst mstr bBox d)

    mstr = dbOpenCellViewByType(libName cellName cellType)
    inst = dbCreateInst(cvid mstr instName origin rotation 1)

   /* Now add the connectivity */

    UvaEceFETAddLabelsToInstPins(cvid inst origin mstr leftPins "left")        
    UvaEceFETAddLabelsToInstPins(cvid inst origin mstr  rightPins "right")        
    UvaEceFETAddLabelsToInstPins(cvid inst origin mstr  topPins "top")        
    UvaEceFETAddLabelsToInstPins(cvid inst origin mstr   botPins "bottom")        

  /* now add the properties */
    dbCreateProp(inst "miX" "string" miX)
    dbCreateProp(inst "mpCell" "string" miX)
    dbCreateProp(inst "wFinger" "string" wFinger)
    dbCreateProp(inst "l" "string" Length)
    dbCreateProp(inst "mi" "string" mi)
    dbCreateProp(inst "B" "string" Bconn)
    if( strcmp(substring(cellName,1,1), "P")==0 then 
	dbCreateProp(inst "SUB" "string" SUBPmos)
	net = dbMakeNet(cvid SUBPmos nil)
        dbCreateConnByName(net inst "SUB")
    );

  return(inst)
  )
)

procedure( UvaEceFETAddLabelsToInstPins(cvid inst origin mstr pinList side)
  prog( (pinPair shape instPinName pinLabel x y newxy stretchxy rotation label line)

      rotation = case(side
        ("left" "R0")
        ("right" "R0")
        ("top" "R90")
        ("bottom" "R270")
      )

    foreach(pinPair pinList
      instPinName = car(pinPair)
      pinLabel = car(last(pinPair))

      net = dbMakeNet(cvid pinLabel nil)
      dbCreateConnByName(net inst instPinName)
      xy = UvaEceGetFETPinCenter(mstr instPinName)
      newxy = UvaEceAddCoords(xy origin)

      x = xCoord(newxy)
      y = yCoord(newxy)
      stretchxy = case(side
        ("left" (x-.2):y)
        ("right" (x+0.2):y)
        ("top" x:(y+.2))
        ("bottom" x:(y-.2))
      )

      line = dbCreateLine(cvid list(228 252) list(newxy stretchxy))~>net=net

      label = dbCreateLabel(cvid list(228 237) stretchxy pinLabel "lowerCenter" rotation "stick" 6.250000e-02)
      label~>isDrafted = t
      label~>isOverbar = nil
      label~>isVisible = t
      label~>labelType = "normalLabel"
    )
        

  return(t)
  )
)

procedure( UvaEceGetFETPinCenter(inst instPinName)
  prog( (x y shape xy bBox x1 x2 y1 y2)
    foreach(shape inst~>shapes
      if( shape~>layerName=="pin" then
        if( car(shape~>net~>sigNames)==instPinName then
          bBox = shape~>bBox
        )
        if( car(cdr(shape~>net~>sigNames))==instPinName then
          bBox = shape~>bBox
        )
      )
    )
  x1 = xCoord(car(bBox))
  x2 = xCoord(car(last(bBox)))
  x  = (x1 + x2)/2

  y1 = yCoord(car(bBox))
  y2 = yCoord(car(last(bBox)))
  y  = (y1 + y2)/2
  xy = x:y

  return(xy)
  )
)

procedure( darSchematicCreateFETInst(cvid libName cellName cellType instName leftPins rightPins topPins botPins origin rotation width length)
  prog((inst mstr bBox d)

    mstr = dbOpenCellViewByType(libName cellName cellType)
    inst = dbCreateInst(cvid mstr instName origin rotation 1)

   /* Now add the connectivity */
    darFETAddLabelsToInstPins(cvid inst origin mstr leftPins "left" rotation)
    darFETAddLabelsToInstPins(cvid inst origin mstr  rightPins "right" rotation)
    darFETAddLabelsToInstPins(cvid inst origin mstr  topPins "top" rotation)
    darFETAddLabelsToInstPins(cvid inst origin mstr   botPins "bottom" rotation)

  /* now add the properties */
    dbCreateProp(inst "w" "float" width)
    dbCreateProp(inst "l" "float" length)

/* These properties were removed per Satya's email on 3-11-11 discussing source/drain
dimensions being set by DRC rules. */
/*
    sprintf(widthString "%L" width)
    dbCreateProp(inst "as" "string" sprintf(nil "pPar(%L)*ls" widthString))
    dbCreateProp(inst "ad" "string" sprintf(nil "pPar(%L)*ld" widthString))
    dbCreateProp(inst "ps" "string" sprintf(nil "2*ls+pPar(%L)" widthString))
    dbCreateProp(inst "pd" "string" sprintf(nil "2*ld+pPar(%L)" widthString))
*/

  return(inst)
  )
)

procedure( darSchematicCreateFET(cvid libName cellName cellType instName leftPins rightPins topPins botPins origin rotation width length)
  prog((inst mstr bBox d)

    mstr = dbOpenCellViewByType(libName cellName cellType)
    inst = dbCreateInst(cvid mstr instName origin rotation 1)

   /* Now add the connectivity */
    darFETAddLabelsToInstPins(cvid inst origin mstr leftPins "left" rotation)
    darFETAddLabelsToInstPins(cvid inst origin mstr  rightPins "right" rotation)
    darFETAddLabelsToInstPins(cvid inst origin mstr  topPins "top" rotation)
    darFETAddLabelsToInstPins(cvid inst origin mstr   botPins "bottom" rotation)

  /* now add the properties */
    dbCreateProp(inst "w" "string" sprintf(nil "pPar(%L)" width))
    dbCreateProp(inst "l" "string" sprintf(nil "pPar(%L)" length))

/* These properties were removed per Satya's email on 3-11-11 discussing source/drain
dimensions being set by DRC rules. */
/*
    dbCreateProp(inst "as" "string" sprintf(nil "pPar(%L)*ls" width))
    dbCreateProp(inst "ad" "string" sprintf(nil "pPar(%L)*ld" width))
    dbCreateProp(inst "ps" "string" sprintf(nil "2*ls+pPar(%L)" width))
    dbCreateProp(inst "pd" "string" sprintf(nil "2*ld+pPar(%L)" width))
*/

  return(inst)
  )
)

procedure( darFETAddLabelsToInstPins(cvid inst origin mstr pinList side rotation0)
  prog( (pinPair shape instPinName pinLabel x y newxy stretchxy rotation label line)

      rotation = case(side
        ("left" "R0")
        ("right" "R0")
        ("top" "R90")
        ("bottom" "R270")
      )

    foreach(pinPair pinList
      instPinName = car(pinPair)
      pinLabel = car(last(pinPair))

      net = dbMakeNet(cvid pinLabel nil)
      dbCreateConnByName(net inst instPinName)

      xy = darGetFETPinCenter(mstr instPinName rotation0)
      newxy = UvaEceAddCoords(xy origin)
      x = xCoord(newxy)
      y = yCoord(newxy)

    if( rotation0 == "R0" then
      stretchxy = case(side
        ("left" (x-.2):y)
        ("right" (x+0.2):y)
        ("top" x:(y+.2))
        ("bottom" x:(y-.2))
      )
    )
    if( rotation0 == "MY" then
      stretchxy = case(side
        ("left" (x+.2):y)
        ("right" (x-0.2):y)
        ("top" x:(y+.2))
        ("bottom" x:(y-.2))
      )
    )
    if( rotation0 == "MYR90" || rotation0 == "R270" then
      stretchxy = case(side
        ("left" x:(y+.2))
        ("right" x:(y-.2))
        ("top" (x-.2):y)
        ("bottom" (x+.2):y)
      )
    )
    if( rotation0 == "R90" then
      stretchxy = case(side
        ("left" x:(y-.2))
        ("right" x:(y+.2))
        ("top" (x-.2):y)
        ("bottom" (x+.2):y)
      )
    )

      line = dbCreateLine(cvid list(228 252) list(newxy stretchxy))~>net=net

      label = dbCreateLabel(cvid list(228 237) stretchxy pinLabel "lowerCenter" rotation "stick" 6.250000e-02)
      label~>isDrafted = t
      label~>isOverbar = nil
      label~>isVisible = t
      label~>labelType = "normalLabel"
    )


  return(t)
  )
)

procedure( darGetFETPinCenter(inst instPinName rotation)
  prog( (x y shape xy bBox x1 x2 y1 y2)
    foreach(shape inst~>shapes
      if( shape~>layerName=="pin" then
        if( car(shape~>net~>sigNames)==instPinName then
          bBox = shape~>bBox
        )
        if( car(cdr(shape~>net~>sigNames))==instPinName then
          bBox = shape~>bBox
        )
      )
    )

      if( rotation == "R0" then
        x1 = xCoord(car(bBox))
        x2 = xCoord(car(last(bBox)))
        x  = (x1 + x2)/2

        y1 = yCoord(car(bBox))
        y2 = yCoord(car(last(bBox)))
        y  = (y1 + y2)/2

        xy = x:y
      )
      if( rotation == "MY" then
        x1 = xCoord(car(bBox))
        x1 = x1
        x2 = xCoord(car(last(bBox)))
        x  = -1*(x1 + x2)/2

        y1 = yCoord(car(bBox))
        y2 = yCoord(car(last(bBox)))
        y  = (y1 + y2)/2
        xy = x:y
      )
      if( rotation == "MYR90" then
        x1 = xCoord(car(bBox))
        x2 = xCoord(car(last(bBox)))
        x0  = (x1 + x2)/2

        y1 = yCoord(car(bBox))
        y2 = yCoord(car(last(bBox)))
        y0 = (y1 + y2)/2

        x  = -y0
        y  = -x0

        xy = x:y
      )
      if( rotation == "R270" then
        x1 = xCoord(car(bBox))
        x2 = xCoord(car(last(bBox)))
        x0  = (x1 + x2)/2

        y1 = yCoord(car(bBox))
        y2 = yCoord(car(last(bBox)))
        y0  = (y1 + y2)/2

        x  = y0
        y  = -x0

        xy = x:y
      )
      if( rotation == "R90" then
        x1 = xCoord(car(bBox))
        x2 = xCoord(car(last(bBox)))
        x0  = (x1 + x2)/2

        y1 = yCoord(car(bBox))
        y2 = yCoord(car(last(bBox)))
        y0  = (y1 + y2)/2

        x  = -y0
        y  = x0

        xy = x:y
      )

  return(xy)
  )
)

procedure( darChooseTerminalCase(technologyCase)
  prog( (terminalUpperCase terminalLowerCase terminalCase)

  ;;create lists for case of terminals
  terminalUpperCase = '("D" "G" "S" "B")
  terminalLowerCase = '("d" "g" "s" "b")

  ;;determine which letter case to use
  terminalCase = case(technologyCase
      ("lower" terminalLowerCase)
      ("upper" terminalUpperCase)
  )

  return(terminalCase)

  )
)






