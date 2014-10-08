
procedure( UvaEceGetBboxCorners( bBox cornerName)
  prog( (xy x y uR lL)
  
   if(bBox==nil then
	printf("ERROR in UvaEceGetBboxCorners - bBox is nil\n")
   )
   uR = car(last(bBox))
   lL = car(bBox)

    xy = case(cornerName
      ("upperRight" uR) 
      ("lowerLeft"  lL)
      ("upperLeft"  xCoord(lL):yCoord(uR))
      ("lowerRight" xCoord(uR):yCoord(lL))
    )
    return(xy)              
  )
)

procedure( UvaEceAddCoords(xy1 xy2)
  prog((xy3 x y)

    x = xCoord(xy1) + xCoord(xy2)
    y = yCoord(xy1) + yCoord(xy2)
    xy3 = x:y

  return(xy3)
  )
)
