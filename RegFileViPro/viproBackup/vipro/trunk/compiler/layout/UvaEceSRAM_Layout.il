/* This is the top-level script that creates the Layout of the SRAM by tiling together the array, peripherals and various filler cells

----------------------
Leaf cells required:
----------------------

By Satyanand Nalam, 04-08-2010
*/

load("jwBasicLayout.il")

procedure( UvaEceCreateSRAMLayout(libName cellName tmgName tmgfName bsfName bitsliceName wlfName wldName arrayName) 
  prog((cvid)
    cvid=dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
    UvaEceDeleteObjectsLayout(cvid)

    ;;;; PLACE CELLS starting from bottom left with the timing block and work upwards 
    xy=0:0

    ; Place timing block and filler
    bBox = UvaEceLayoutCreateInst(cvid libName tmgName "layout" "ITMNG" xy "R0" UvaEceBBoxLayerName)
    xy = UvaEceGetBboxCorners(bBox,"lowerRight")
    ; height of timing block to get y-coord of point to place timing filler
    xy1 = UvaEceGetBboxCorners(bBox,"upperRight")
    y = yCoord(xy1)

    bBox = UvaEceLayoutCreateInst(cvid libName tmgfName "layout" "ITMNGF" xy "R0" UvaEceBBoxLayerName)
    xy = UvaEceGetBboxCorners(bBox,"lowerRight")

    bBox = UvaEceLayoutCreateInst(cvid libName bsfName "layout" "IBSF" xy "R0" UvaEceBBoxLayerName)
    xy = UvaEceGetBboxCorners(bBox,"upperLeft")

    bBox = UvaEceLayoutCreateInst(cvid libName bitsliceName "layout" "IBS" xy "R0" UvaEceBBoxLayerName)
    xy = 0:y

    bBox = UvaEceLayoutCreateInst(cvid libName wlfName "layout" "IWLDLF" xy "R0" UvaEceBBoxLayerName)
    xy = UvaEceGetBboxCorners(bBox,"lowerRight")

    bBox = UvaEceLayoutCreateInst(cvid libName wldName "layout" "IWLD" xy "R0" UvaEceBBoxLayerName)
    xy = UvaEceGetBboxCorners(bBox,"lowerRight")

    ; Place array
    bBox = UvaEceLayoutCreateInst(cvid libName arrayName "layout" "IBC" xy "R0" UvaEceBBoxLayerName)
    pUR = UvaEceGetBboxCorners(bBox,"upperRight")


    ;;;; CREATE PINS
    svnCreatePins(cvid "AR" "AR" "ITMNG" M3 ?bus "sameInst" ?busWidth 9) 
    svnCreatePins(cvid "AC" "AC" "ITMNG" M3 ?bus "sameInst" ?busWidth 3) 
    svnCreatePins(cvid "SA_CTRL" "SA_CTRL" "ITMNG" M2 ?bus "sameInst" ?busWidth 2)
    svnCreatePins(cvid "WL_CTRL" "WL_CTRL" "ITMNG" M2 ?bus "sameInst" ?busWidth 2)
    svnCreatePins(cvid "CLK" "CLK" "ITMNG" M2)
    svnCreatePins(cvid "WR" "WR" "ITMNG" M2)
    svnCreatePins(cvid "vdd" "VDD" "ITMNG" M1)
    svnCreatePins(cvid "gnd" "VSS" "ITMNG" M1)

    svnCreatePins(cvid "DIN" "DATA_IN" "IBS" M2 ?bus "sameInst" ?busWidth 16)
    svnCreatePins(cvid "DOUT" "DATA_OUT" "IBS" M2 ?bus "sameInst" ?busWidth 16)
    
    ;;;; PLACE BOUNDARY
    pLL = 0:0
    ;jwLayoutCreateBbox(cvid list(pLL pUR))
    dbSave(cvid)
    dbClose(cvid)
    return(t)
  )
)

let((libName cellName tapPitch R C)
  R=128
  C=16
  W=16
  libName="highTempSRAM"
  sprintf(cellName "SRAM_%dx%d_%d" R C W)

  tmgName="TIMING_UNION"
  tmgfName="TMGDMM_RIGHT_FILLER16"
  bsfName="BITSLICEDMM_BOT_FILLER16"
  bitsliceName="BITSLICE_DMM"
  wlfName="WLDRIVERDMM_LEFT_FILLER128"
  wldName="WLDRIVERDMM_128"
  arrayName="bcArray_128x16"

  ;Call scripts to layout - WLDRIVER, ARRAY, and BITSLICE

  ;Call procedure defined in this script for top-level integration of all components
  UvaEceCreateSRAMLayout(libName "testDavRAM1" tmgName tmgfName bsfName bitsliceName wlfName wldName arrayName) 
)
