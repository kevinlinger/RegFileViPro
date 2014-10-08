;;;;-----------------------------------
/* SKILL script to generate schematics for any technology
   Tested using the 45nm FreePDK

   By Daniel Reyno, 10.15.10
*/

load("./skill/darUvaEceSchematic.il")
load("./skill/jwBasicSchematic.il")
load("./skill/darBasicSchematic.il")



  ;; retrieve minimum sizes from association table
  wpMin = minSizeTable["wpMin"]
  wnMin = minSizeTable["wnMin"]
  lpMin = minSizeTable["lpMin"]
  lnMin = minSizeTable["lnMin"]

;;;;
;;;; To create schematic of an inverter with specific size
;;;;
procedure( darCreateInverterSchematic(libName cellName FETlibName
	PMOScellName NMOScellName technologyCase)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; SUPPLY NETS
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("IN")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  ;; OUTPUT
  printf("creating output pin\n")
    foreach(pinName list("OUT")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  ;; FETs
  printf("placing FETs\n")

  ;;create PMOS
  inst = darSchematicCreateFET(cvid FETlibName PMOScellName "symbol" "P0"
    list(list(gate "IN"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "OUT"))
    0.75:-0.5 "R0" "wp" "lp")

  ;;create NMOS
  darSchematicCreateFET(cvid FETlibName NMOScellName "symbol" "N0"
    list(list(gate "IN"))
    list(list(bulk "VSS"))
    list(list(drain "OUT"))
    list(list(source "VSS"))
    0.75:-1.75 "R0" "wn" "ln")

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

  ;; parameterize the inverter
  darCreateParInverter(libName cellName wpMin wnMin lpMin lnMin)

)

procedure( darCreateParInverter(libName cellName wp wn lp ln)

  cellId = ddGetObj( libName cellName )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wp"
    ?type "string"
    ?prompt "wp"
    ?units "lengthMetric"
    ?defValue wp
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wn"
    ?type "string"
    ?prompt "wn"
    ?units "lengthMetric"
    ?defValue wn
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "lp"
    ?type "string"
    ?prompt "lp"
    ?units "lengthMetric"
    ?defValue lp
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "ln"
    ?type "string"
    ?prompt "ln"
    ?units "lengthMetric"
    ?defValue ln
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

) ;;end procedure

;;;;
;;;; To create schematic of a buffer with specific size
;;;;
procedure( darCreateBufferSchematic(libName cellName FETlibName
	PMOScellName NMOScellName technologyCase)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; SUPPLY NETS
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("IN")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  ;; OUTPUT
  printf("creating output pin\n")
    foreach(pinName list("OUT")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  ;; FETs
  printf("placing FETs\n")

  /* create first inverter */
  ;;create PMOS
  inst = darSchematicCreateFET(cvid FETlibName PMOScellName "symbol" "P0"
    list(list(gate "IN"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "X"))
    0.75:-0.5 "R0" "wp1" "lp1")

  ;;create NMOS
  inst = darSchematicCreateFET(cvid FETlibName NMOScellName "symbol" "N0"
    list(list(gate "IN"))
    list(list(bulk "VSS"))
    list(list(drain "X"))
    list(list(source "VSS"))
    0.75:-1.75 "R0" "wn1" "ln1")

  /* create second inverter */
  ;;create PMOS
  inst = darSchematicCreateFET(cvid FETlibName PMOScellName "symbol" "P1"
    list(list(gate "X"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "OUT"))
    2:-0.5 "R0" "wp2" "lp2")

  ;;create NMOS
  inst = darSchematicCreateFET(cvid FETlibName NMOScellName "symbol" "N1"
    list(list(gate "X"))
    list(list(bulk "VSS"))
    list(list(drain "OUT"))
    list(list(source "VSS"))
    2:-1.75 "R0" "wn2" "ln2")

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

  darCreateParBuffer(libName cellName wpMin wnMin lpMin lnMin wpMin wnMin lpMin lnMin)

)

procedure( darCreateParBuffer(libName cellName wp1 wn1 lp1 ln1 wp2 wn2 lp2 ln2)

  cellId = ddGetObj( libName cellName )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wp1"
    ?type "string"
    ?prompt "wp1"
    ?units "lengthMetric"
    ?defValue wp1
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wn1"
    ?type "string"
    ?prompt "wn1"
    ?units "lengthMetric"
    ?defValue wn1
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "lp1"
    ?type "string"
    ?prompt "lp1"
    ?units "lengthMetric"
    ?defValue lp1
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "ln1"
    ?type "string"
    ?prompt "ln1"
    ?units "lengthMetric"
    ?defValue ln1
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wp2"
    ?type "string"
    ?prompt "wp2"
    ?units "lengthMetric"
    ?defValue wp2
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wn2"
    ?type "string"
    ?prompt "wn2"
    ?units "lengthMetric"
    ?defValue wn2
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "lp2"
    ?type "string"
    ?prompt "lp2"
    ?units "lengthMetric"
    ?defValue lp2
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "ln2"
    ?type "string"
    ?prompt "ln2"
    ?units "lengthMetric"
    ?defValue ln2
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

) ;;end procedure

;;;;
;;;; To create schematic of a 2-input NAND with specific size
;;;;
procedure( darCreateNAND2Schematic(libName cellName FETlibName
	PMOScellName NMOScellName technologyCase)

  ;;instantiate a newschematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; INPUTS
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("INA" "INB")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  ;; OUTPUT
  printf("creating output pin\n")
    foreach(pinName list("OUT")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  ;; FETs
  printf("placing FETs\n")

  ;;create PMOS
  darSchematicCreateFET(cvid FETlibName PMOScellName "symbol" "P0"
    list(list(gate "INA"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "OUT"))
    0.75:0 "R0" "wp" "lp")

  darSchematicCreateFET(cvid FETlibName PMOScellName "symbol" "P1"
    list(list(gate "INB"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "OUT"))
    2:0 "R0" "wp" "lp")

  ;;create NMOS
  darSchematicCreateFET(cvid FETlibName NMOScellName "symbol" "N0"
    list(list(gate "INA"))
    list(list(bulk "VSS"))
    list(list(drain "OUT"))
    list(list(source "X"))
    1.35:-1 "R0" "wn" "ln")

  darSchematicCreateFET(cvid FETlibName NMOScellName "symbol" "N1"
    list(list(gate "INB"))
    list(list(bulk "VSS"))
    list(list(drain "X"))
    list(list(source "VSS"))
    1.35:-2 "R0" "wn" "ln")

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

  ;; parameterize the NAND gate
  darCreateParNand2(libName cellName wpMin wnMin lpMin lnMin)

)


procedure( darCreateParNand2(libName cellName wp wn lp ln)

  cellId = ddGetObj( libName cellName )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wp"
    ?type "string"
    ?prompt "wp"
    ?units "lengthMetric"
    ?defValue wp
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wn"
    ?type "string"
    ?prompt "wn"
    ?units "lengthMetric"
    ?defValue sprintf(nil "2*%s" wn)
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "lp"
    ?type "string"
    ?prompt "lp"
    ?units "lengthMetric"
    ?defValue lp
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "ln"
    ?type "string"
    ?prompt "ln"
    ?units "lengthMetric"
    ?defValue ln
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

) ;;end procedure

;;;;
;;;; To create schematic of a 2-input AND with specific size
;;;;
procedure( darCreateAND2Schematic(libName cellName FETlibName
	PMOScellName NMOScellName technologyCase)

  ;;instantiate a newschematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; SUPPLY NETS
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("INA" "INB")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  ;; OUTPUT
  printf("creating output pin\n")
    foreach(pinName list("OUT")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  ;; FETs
  printf("placing FETs\n")

  /* create NAND */
  ;;create PMOS
  darSchematicCreateFET(cvid FETlibName PMOScellName "symbol" "P0"
    list(list(gate "INA"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "OUTB"))
    0.75:0 "R0" "wpNAND" "lpNAND")

  darSchematicCreateFET(cvid FETlibName PMOScellName "symbol" "P1"
    list(list(gate "INB"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "OUTB"))
    2:0 "R0" "wpNAND" "lpNAND")

  ;;create NMOS
  darSchematicCreateFET(cvid FETlibName NMOScellName "symbol" "N0"
    list(list(gate "INA"))
    list(list(bulk "VSS"))
    list(list(drain "OUTB"))
    list(list(source "X"))
    1.35:-1 "R0" "wnNAND" "lnNAND")

  darSchematicCreateFET(cvid FETlibName NMOScellName "symbol" "N1"
    list(list(gate "INB"))
    list(list(bulk "VSS"))
    list(list(drain "X"))
    list(list(source "VSS"))
    1.35:-2 "R0" "wnNAND" "lnNAND")

  /* create INVERTER */
  darSchematicCreateFET(cvid FETlibName PMOScellName "symbol" "P2"
    list(list(gate "OUTB"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "OUT"))
    3.25:-0.5 "R0" "wpINV" "lpINV")

  darSchematicCreateFET(cvid FETlibName NMOScellName "symbol" "N2"
    list(list(gate "OUTB"))
    list(list(bulk "VSS"))
    list(list(drain "OUT"))
    list(list(source "VSS"))
    3.25:-1.5 "R0" "wnINV" "lnINV")

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

  ;; parameterize the AND gate
  darCreateParAnd2(libName cellName wpMin wnMin lpMin lnMin wpMin wnMin lpMin lnMin)
)

procedure( darCreateParAnd2(libName cellName wpNAND wnNAND lpNAND lnNAND wpINV wnINV lpINV lnINV)

  cellId = ddGetObj( libName cellName )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wpNAND"
    ?type "string"
    ?prompt "wpNAND"
    ?units "lengthMetric"
    ?defValue wpNAND
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wnNAND"
    ?type "string"
    ?prompt "wnNAND"
    ?units "lengthMetric"
    ?defValue sprintf(nil "2*%s" wnNAND)
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wpINV"
    ?type "string"
    ?prompt "wpINV"
    ?units "lengthMetric"
    ?defValue wpINV
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wnINV"
    ?type "string"
    ?prompt "wnINV"
    ?units "lengthMetric"
    ?defValue wnINV
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "lpNAND"
    ?type "string"
    ?prompt "lpNAND"
    ?units "lengthMetric"
    ?defValue lpNAND
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "lnNAND"
    ?type "string"
    ?prompt "lnNAND"
    ?units "lengthMetric"
    ?defValue lnNAND
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "lpINV"
    ?type "string"
    ?prompt "lpINV"
    ?units "lengthMetric"
    ?defValue lpINV
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "lnINV"
    ?type "string"
    ?prompt "lnINV"
    ?units "lengthMetric"
    ?defValue lnINV
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

) ;;end procedure

;;;;
;;;; To create schematic of a 2-input NOR with specific size
;;;;
procedure( darCreateNOR2Schematic(libName cellName FETlibName
	PMOScellName NMOScellName technologyCase)

  ;;instantiate a newschematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; SUPPLY NETS
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("INA" "INB")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  ;; OUTPUT
  printf("creating output pin\n")
    foreach(pinName list("OUT")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  ;; FETs
  printf("placing FETs\n")

  ;;create PMOS
  inst = darSchematicCreateFET(cvid FETlibName PMOScellName "symbol" "P0"
    list(list(gate "INA"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "X"))
    1.5:0 "R0" "wp" "lp")

  inst = darSchematicCreateFET(cvid FETlibName PMOScellName "symbol" "P1"
    list(list(gate "INB"))
    list(list(bulk "VDD"))
    list(list(source "X"))
    list(list(drain "OUT"))
    1.5:-0.9 "R0" "wp" "lp")

  ;;create NMOS
  inst = darSchematicCreateFET(cvid FETlibName NMOScellName "symbol" "N0"
    list(list(gate "INA"))
    list(list(bulk "VSS"))
    list(list(drain "OUT"))
    list(list(source "VSS"))
    1:-1.85 "R0" "wn" "ln")

  inst = darSchematicCreateFET(cvid FETlibName NMOScellName "symbol" "N1"
    list(list(gate "INB"))
    list(list(bulk "VSS"))
    list(list(drain "OUT"))
    list(list(source "VSS"))
    2.25:-1.85 "R0" "wn" "ln")

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

  ;; parameterize the NOR gate
  darCreateParNor2(libName cellName wpMin wnMin lpMin lnMin)

)

procedure( darCreateParNor2(libName cellName wp wn lp ln)

  cellId = ddGetObj( libName cellName )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wp"
    ?type "string"
    ?prompt "wp"
    ?units "lengthMetric"
    ?defValue sprintf(nil "2*%s" wp)
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wn"
    ?type "string"
    ?prompt "wn"
    ?units "lengthMetric"
    ?defValue wn
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "lp"
    ?type "string"
    ?prompt "lp"
    ?units "lengthMetric"
    ?defValue lp
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "ln"
    ?type "string"
    ?prompt "ln"
    ?units "lengthMetric"
    ?defValue ln
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

) ;;end procedure

;;;;
;;;; To create schematic of a Transmission Gate
;;;;
procedure( darCreateTXGateSchematic(libName cellName FETlibName
	PMOScellName NMOScellName technologyCase @key (wp wpMin)
	(lp lpMin) (wn wnMin) (ln lnMin))

  wp = cdfParseFloatString(wp)
  wn = cdfParseFloatString(wn)
  lp = cdfParseFloatString(lp)
  ln = cdfParseFloatString(ln)

  ;;instantiate a newschematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; INPUTS
  printf("creating supply net pins\n")
    foreach(pinName list("VDD" "VSS" "IN" source "SBAR")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  ;;OUTPUT
  printf("creating input-output pins\n")
    foreach(pinName list("OUT")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  ;; FETs
  printf("placing FETs\n")

  ;;create NMOS
  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "N0"
    list(list(gate source))
    list(list(bulk "VSS"))
    list(list(drain "OUT"))
    list(list(source "IN"))
    0.75:-1 "R0" wn ln)

  ;;create PMOS
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "P0"
    list(list(gate "SBAR"))
    list(list(bulk "VDD"))
    list(list(source "OUT"))
    list(list(drain "IN"))
    2.5:-1 "MY" wp lp)

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;;
;;;; To create schematic of a tri-state inverter with specific size
;;;;
procedure( darCreateTriStateInverterSchematic(libName cellName FETlibName
	PMOScellName NMOScellName technologyCase)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0.25

  ;; SUPPLY NETS
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("TRIP" "IN" "TRIN")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  x = 1.5
  y = -1.25
  ;; OUTPUT
  printf("creating output pin\n")
    foreach(pinName list("OUT")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  ;; FETs
  printf("placing FETs\n")

  ;;create PMOS of INV
  darSchematicCreateFET(cvid FETlibName PMOScellName "symbol" "P0"
    list(list(gate "IN"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "X0"))
    0.75:0.75 "R0" "wpINV" "lpINV")

  ;;create PMOS of enabler
  darSchematicCreateFET(cvid FETlibName PMOScellName "symbol" "P1"
    list(list(gate "TRIP"))
    list(list(bulk "VDD"))
    list(list(source "X0"))
    list(list(drain "OUT"))
    0.75:-0.5 "R0" "wpEN" "lpEN")

  ;;create NMOS of enabler
  darSchematicCreateFET(cvid FETlibName NMOScellName "symbol" "N0"
    list(list(gate "TRIN"))
    list(list(bulk "VSS"))
    list(list(drain "OUT"))
    list(list(source "X1"))
    0.75:-1.75 "R0" "wnEN" "lnEN")

  ;;create NMOS
  darSchematicCreateFET(cvid FETlibName NMOScellName "symbol" "N1"
    list(list(gate "IN"))
    list(list(bulk "VSS"))
    list(list(drain "X1"))
    list(list(source "VSS"))
    0.75:-3 "R0" "wnINV" "lnINV")

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

  darCreateParTriStateInverter(libName cellName wpMin wpMin wnMin wnMin lpMin lpMin lnMin lnMin)

)


procedure( darCreateParTriStateInverter(libName cellName wpINV wpEN wnEN wnINV lpINV lpEN lnEN lnINV)

  cellId = ddGetObj( libName cellName )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wpINV"
    ?type "string"
    ?prompt "wpINV"
    ?units "lengthMetric"
    ?defValue wpINV
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wpEN"
    ?type "string"
    ?prompt "wpEN"
    ?units "lengthMetric"
    ?defValue wpEN
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wnEN"
    ?type "string"
    ?prompt "wnEN"
    ?units "lengthMetric"
    ?defValue wnEN
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "wnINV"
    ?type "string"
    ?prompt "wnINV"
    ?units "lengthMetric"
    ?defValue wnINV
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "lpINV"
    ?type "string"
    ?prompt "lpINV"
    ?units "lengthMetric"
    ?defValue lpINV
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "lpEN"
    ?type "string"
    ?prompt "lpEN"
    ?units "lengthMetric"
    ?defValue lpEN
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "lnEN"
    ?type "string"
    ?prompt "lnEN"
    ?units "lengthMetric"
    ?defValue lnEN
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

  cdfId = cdfCreateBaseCellCDF( cellId )
  cdfCreateParam( cdfId
    ?name "lnINV"
    ?type "string"
    ?prompt "lnINV"
    ?units "lengthMetric"
    ?defValue lnINV
    ?use "t"
    ?display "t"
    ?editable "t"
    ?dontSave "nil"
    ?parseAsNumber "yes"
    ?parseAsCEL "yes"
  )

) ;;end procedure


;;;;
;;;; To create schematic of the 6T bitcell with specific size
;;;;
procedure( darCreateBitcellSchematic(libName cellName FETlibName
	PMOScellName NMOScellName technologyCase @key (wpg wnMin)
	(lpg lnMin) (wpu wpMin) (lpu lpMin) (wpd wnMin) (lpd lnMin))

println(wpg)
println(wpu)
println(wpd)
println(lpg)
println(lpu)
println(lpd)



  wpg = cdfParseFloatString(wpg)
  lpg = cdfParseFloatString(lpg)
  wpu = cdfParseFloatString(wpu)
  lpu = cdfParseFloatString(lpu)
  wpd = cdfParseFloatString(wpd)
  lpd = cdfParseFloatString(lpd)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("WL")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  ;; OUTPUT
  printf("creating input-output pins\n")
    foreach(pinName list("BL" "BLB" "VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  ;; FETs
  printf("placing FETs\n")

  ;;create top inverter
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M4"
    list(list(gate "Q"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "QB"))
    3.5:0 "R0" wpu lpu)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M3"
    list(list(gate "Q"))
    list(list(bulk "VSS"))
    list(list(drain "QB"))
    list(list(source "VSS"))
    3.5:-1.5 "R0" wpd lpd)

  ;;create bottom inverter
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M2"
    list(list(gate "QB"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "Q"))
    2.5:0 "MY" wpu lpu)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M1"
    list(list(gate "QB"))
    list(list(bulk "VSS"))
    list(list(drain "Q"))
    list(list(source "VSS"))
    2.5:-1.5 "MY" wpd lpd)

  ;;create pass gates
  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M5"
    list(list(gate "WL"))
    list(list(bulk "VSS"))
    list(list(drain "BL"))
    list(list(source "Q"))
    1:-0.5 "MYR90" wpg lpg)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M6"
    list(list(gate "WL"))
    list(list(bulk "VSS"))
    list(list(source "QB"))
    list(list(drain "BLB"))
    5:-0.5 "R270" wpg lpg)

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;;
;;;; To create schematic of the Sense Amp
;;;;
procedure( darCreateSenseAmpSchematic(libName cellName FETlibName
	PMOScellName NMOScellName technologyCase cellName_nand @key (wen wnMin)
	(len lnMin) (weql wpMin) (leql wpMin) (wpsa wpMin) (lpsa lpMin)
	(wnsa wnMin) (lnsa lnMin) (wbl wnMin) (lbl lnMin) (wsapc wpMin)
	(lsapc lpMin) (wpNAND wpMin) (lpNAND lpMin) (wnNAND wnMin)
	(lnNAND lnMin))

  wen = cdfParseFloatString(wen)
  len = cdfParseFloatString(len)
  weql = cdfParseFloatString(weql)
  leql = cdfParseFloatString(leql)
  wpsa = cdfParseFloatString(wpsa)
  lpsa = cdfParseFloatString(lpsa)
  wnsa = cdfParseFloatString(wnsa)
  lnsa = cdfParseFloatString(lnsa)
  wbl = cdfParseFloatString(wbl)
  lbl = cdfParseFloatString(lbl)
  wsapc = cdfParseFloatString(wsapc)
  lsapc = cdfParseFloatString(lsapc)

  ;;instantiate a newschematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 2
  dy = 0.5

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; SUPPLY NETS
  printf("creating supply net pins\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  y = y - dy

  ;; INPUTS
  pin=UvaEceSchematicCreatePin(cvid "SAE" "input" 2.75:0.5 "R0")
  pin=UvaEceSchematicCreatePin(cvid "SAPREC" "input" 0:-3 "R0")

  x = 1.5
  y = -4

  ;;INPUT-OUTPUT
  printf("creating input-output pins\n")
    foreach(pinName list("RDWR" "NRDWR")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      x=x+3
    )

  ;;Output
  pin = UvaEceSchematicCreatePin(cvid "SD" "output" 7.5:-2 "R0")

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  x=dx
  y=y+dy

  ;; FETs
  printf("placing FETs\n")

  ;;create out/outb precharge/equalize transistors
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M0"
    list(list(gate "SAE"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "OUTB"))
    1.75:0.25 "MY" weql leql)

  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M1"
    list(list(gate "SAE"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "OUT"))
    3.65:0.25 "R0" weql leql)

  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M2"
    list(list(gate "SAE"))
    list(list(bulk "VDD"))
    list(list(drain "OUTB"))
    list(list(source "OUT"))
    2.7:-0.1 "R270" weql leql)

  ;;create cross coupled inverters
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M3"
    list(list(gate "OUT"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "OUTB"))
    2.25:-1.25 "MY" wpsa lpsa)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M4"
    list(list(gate "OUT"))
    list(list(bulk "VSS"))
    list(list(drain "OUTB"))
    list(list(source "xin"))
    2.25:-2.45 "MY" wnsa lnsa)

  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M5"
    list(list(gate "OUTB"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "OUT"))
    3.15:-1.25 "R0" wpsa lpsa)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M6"
    list(list(gate "OUTB"))
    list(list(bulk "VSS"))
    list(list(drain "OUT"))
    list(list(source "xinb"))
    3.15:-2.45 "R0" wnsa lnsa)

  ;;create BL/BLB input transistors
  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M7"
    list(list(gate "RDWR"))
    list(list(bulk "VSS"))
    list(list(drain "xin"))
    list(list(source "COM"))
    1.75:-3.5 "R0" wbl lbl)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M8"
    list(list(gate "NRDWR"))
    list(list(bulk "VSS"))
    list(list(drain "xinb"))
    list(list(source "COM"))
    3.7:-3.5 "MY" wbl lbl)

  ;;create BL/BLB precharge transistors
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M9"
    list(list(gate "SAPREC"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "RDWR"))
    0.75:-3 "R0" wsapc lsapc)

  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M10"
    list(list(gate "SAPREC"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "NRDWR"))
    4.75:-3 "MY" wsapc lsapc)

  ;;create SAEnable transistor
  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M11"
    list(list(gate "SAE"))
    list(list(bulk "VSS"))
    list(list(drain "COM"))
    list(list(source "VSS"))
    2.5:-4.25 "R0" wen len)

  ;;NAND-base SR latch
  inst = darUvaEceSchematicCreateInstParNand2(cvid libName cellName_nand "SRNAND0"
		"OUT"
		"SD"
		"SDB"
		"VDD"
		"VSS"
		5.25:-0.5
		?wp wpNAND ?wn wnNAND ?lp lpNAND ?ln lnNAND)

  inst = darUvaEceSchematicCreateInstParNand2(cvid libName cellName_nand "SRNAND1"
		"OUTB"
		"SDB"
		"SD"
		"VDD"
		"VSS"
		5.25:-2
		?wp wpNAND ?wn wnNAND ?lp lpNAND ?ln lnNAND)

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;;
;;;; To create schematic of a single column CD
;;;;
procedure( darCreateSingleCDSchematic(libName cellName FETlibName
	PMOScellName NMOScellName technologyCase @key (wpc wpMin)
	(lpc lpMin) (wpTX wpMin) (lpTX lpMin) (wnTX wnMin) (lnTX lnMin))

  wpc = cdfParseFloatString(wpc)
  lpc = cdfParseFloatString(lpc)
  wpTX = cdfParseFloatString(wpTX)
  lpTX = cdfParseFloatString(lpTX)
  wnTX = cdfParseFloatString(wnTX)
  lnTX = cdfParseFloatString(lnTX)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 2.5
  dy = 0.5

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; INPUTS
  ;; supply nets
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  y = y - dy

  ;;input signals
    printf("creating supply nets\n")
    foreach(pinName list("CSEL" "CSELB" "PCH")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  x = 1.5
  y = 0
  ;;input/output signals
    printf("creating supply nets\n")
    foreach(pinName list("BL" "RDWR")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-3
    )

  x = 4.25
  y = 0
  ;;input/output signals
    printf("creating supply nets\n")
    foreach(pinName list("BLB" "NRDWR")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-3
    )

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  ;; FETs
  printf("placing FETs\n")

  ;;create BL/BLB precharge/equalize transistors
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M0"
    list(list(gate "PCH"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "BL"))
    0.5:-0.5 "R0" wpc lpc)

  ;;create BL/BLB precharge/equalize transistors
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M1"
    list(list(gate "PCH"))
    list(list(bulk "VDD"))
    list(list(drain "BL"))
    list(list(source "BLB"))
    3:-0.75 "R270" wpc lpc)

  ;;create BL/BLB precharge/equalize transistors
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M2"
    list(list(gate "PCH"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "BLB"))
    5.25:-0.5 "MY" wpc lpc)

  ;;create TXGate for MUX
  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M3"
  list(list(gate "CSEL"))
  list(list(bulk "VSS"))
  list(list(drain "BL"))
  list(list(source "RDWR"))
  0.75:-2 "R0" wnTX lnTX)

  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M4"
  list(list(gate "CSELB"))
  list(list(bulk "VDD"))
  list(list(source "BL"))
  list(list(drain "RDWR"))
  2.4:-2 "MY" wpTX lpTX)

  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M5"
  list(list(gate "CSELB"))
  list(list(bulk "VDD"))
  list(list(source "BLB"))
  list(list(drain "NRDWR"))
  3.5:-2 "R0" wpTX lpTX)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M6"
  list(list(gate "CSEL"))
  list(list(bulk "VSS"))
  list(list(drain "BLB"))
  list(list(source "NRDWR"))
  5.05:-2 "MY" wnTX lnTX)

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;;
;;;; To create schematic of a multi column CD
;;;;
procedure( darCreateMultiCDSchematic(libName cellName FETlibName
	PMOScellName NMOScellName technologyCase MUX @key (wpc wpMin)
	(lpc lpMin) (wpTX wpMin) (lpTX lpMin) (wnTX wnMin) (lnTX lnMin))

  wpc = cdfParseFloatString(wpc)
  lpc = cdfParseFloatString(lpc)
  wpTX = cdfParseFloatString(wpTX)
  lpTX = cdfParseFloatString(lpTX)
  wnTX = cdfParseFloatString(wnTX)
  lnTX = cdfParseFloatString(lnTX)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 2.5
  dy = 0.5

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; INPUTS
  ;; supply nets
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  y = y - dy

  ;;input signals
    printf("creating supply nets\n")
    foreach(pinName list(sprintf(nil "CSEL<0:%d>" MUX-1) sprintf(nil "CSELB<0:%d>" MUX-1) "PCH")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  x = 1.5
  y = 0
  ;;input/output signals
    printf("creating supply nets\n")
    foreach(pinName list(sprintf(nil "BL<0:%d>" MUX-1) "RDWR")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-3
    )

  x = 4.25
  y = 0
  ;;input/output signals
    printf("creating supply nets\n")
    foreach(pinName list(sprintf(nil "BLB<0:%d>" MUX-1) "NRDWR")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-3
    )

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  ;; FETs
  printf("placing FETs\n")

  ;;create BL/BLB precharge/equalize transistors
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" sprintf(nil "M0<0:%d>" MUX-1)
    list(list(gate "PCH"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain sprintf(nil "BL<0:%d>" MUX-1)))
    0.5:-0.5 "R0" wpc lpc)

  ;;create BL/BLB precharge/equalize transistors
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" sprintf(nil "M1<0:%d>" MUX-1)
    list(list(gate "PCH"))
    list(list(bulk "VDD"))
    list(list(drain sprintf(nil "BL<0:%d>" MUX-1)))
    list(list(source sprintf(nil "BLB<0:%d>" MUX-1)))
    3:-0.75 "R270" wpc lpc)

  ;;create BL/BLB precharge/equalize transistors
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" sprintf(nil "M2<0:%d>" MUX-1)
    list(list(gate "PCH"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain sprintf(nil "BLB<0:%d>" MUX-1)))
    5.25:-0.5 "MY" wpc lpc)

  ;;create TXGate for MUX
  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" sprintf(nil "M3<0:%d>" MUX-1)
  list(list(gate sprintf(nil "CSEL<0:%d>" MUX-1)))
  list(list(bulk "VSS"))
  list(list(drain sprintf(nil "BL<0:%d>" MUX-1)))
  list(list(source "RDWR"))
  0.75:-2 "R0" wnTX lnTX)

  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" sprintf(nil "M4<0:%d>" MUX-1)
  list(list(gate sprintf(nil "CSELB<0:%d>" MUX-1)))
  list(list(bulk "VDD"))
  list(list(source sprintf(nil "BL<0:%d>" MUX-1)))
  list(list(drain "RDWR"))
  2.4:-2 "MY" wpTX lpTX)

  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" sprintf(nil "M5<0:%d>" MUX-1)
  list(list(gate sprintf(nil "CSELB<0:%d>" MUX-1)))
  list(list(bulk "VDD"))
  list(list(source sprintf(nil "BLB<0:%d>" MUX-1)))
  list(list(drain "NRDWR"))
  3.5:-2 "R0" wpTX lpTX)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" sprintf(nil "M6<0:%d>" MUX-1)
  list(list(gate sprintf(nil "CSEL<0:%d>" MUX-1)))
  list(list(bulk "VSS"))
  list(list(drain sprintf(nil "BLB<0:%d>" MUX-1)))
  list(list(source "NRDWR"))
  5.05:-2 "MY" wnTX lnTX)

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;;
;;;; To choose between single or multi column CD
;;;;
procedure( darChooseAndCreateCDSchematic(libName cellName FETlibName
	PMOScellName NMOScellName technologyCase C DW @key (wpc wpMin)
	(lpc lpMin) (wpTX wpMin) (lpTX lpMin) (wnTX wnMin) (lnTX lnMin))

  MUX=C/DW

  ;; choose then create how many columns CD
  if( C/DW !=1 then
    darCreateMultiCDSchematic(libName cellName FETlibName PMOScellName NMOScellName technologyCase MUX ?wpc wpc ?lpc lpc ?wpTX wpTX ?lpTX lpTX ?wnTX wnTX ?lnTX lnTX)
  else
    darCreateSingleCDSchematic(libName cellName FETlibName PMOScellName NMOScellName technologyCase ?wpc wpc ?lpc lpc ?wpTX wpTX ?lpTX lpTX ?wnTX wnTX ?lnTX lnTX)
  )

)

;;;;
;;;; To create schematic of DFF
;;;;
procedure( darCreateDFFSchematic(libName cellName FETlibName PMOScellName
	NMOScellName technologyCase @key (minWp wpMin) (minLp lpMin)
	(minWn wnMin) (minLn lnMin))

  minWp = cdfParseFloatString(minWp)
  minLp = cdfParseFloatString(minLp)
  minWn = cdfParseFloatString(minWn)
  minLn = cdfParseFloatString(minLn)

  ;; compute sizing for all FETs
  wpBuffer = 1.5*minWp
  wnBuffer = 1.5*minWn

  wpTSI0 = 1.8*minWp
  wnTSI0 = minWn

  wpTSI1 = minWp
  wnTSI1 = minWn

  wpINV0 = 1.5*minWp
  wnINV0 = minWn

  wpINV1 = 1.35*minWp
  wnINV1 = 1.35*minWn

  wpTX = 1.35*minWp
  wnTX = 1.35*minWn

  wpINV2 = minWp
  wnINV2 = minWn

  wpTSI2 = minWp
  wnTSI2 = 0.75*minWn

  wpINV3 = 2.7*minWp
  wnINV3 = 1.95*minWn


  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 5
  dy = 2.75

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; INPUTS
  printf("creating CLK pin\n")
  pin=UvaEceSchematicCreatePin(cvid "CLK" "input" 0:0 "R0")
  printf("creating input pin D\n")
  pin=UvaEceSchematicCreatePin(cvid "D" "input" 0:-2.75 "R0")

  x = x + dx
  y = 0

  ;; Supply Nets
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  printf("creating output pin Q\n")
  UvaEceSchematicCreatePin(cvid "Q" "output" 8.25:-7.5 "R0")

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  ;; FETs
  printf("placing FETs\n")

  ;;create inverters for clock signals
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M0"
    list(list(gate "CLK"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "CPN"))
    0.75:0.5 "R0" wpBuffer minLp)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M1"
    list(list(gate "CLK"))
    list(list(bulk "VSS"))
    list(list(drain "CPN"))
    list(list(source "VSS"))
    0.75:-0.5 "R0" wnBuffer minLn)

  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M2"
    list(list(gate "CPN"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "CPI"))
    2:0.5 "R0" wpBuffer minLp)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M3"
    list(list(gate "CPN"))
    list(list(bulk "VSS"))
    list(list(drain "CPI"))
    list(list(source "VSS"))
    2:-0.5 "R0" wnBuffer minLn)

  ;;first tri-state inverter stage
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M4"
    list(list(gate "D"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "A0"))
    1:-1.75 "R0" wpTSI0 minLp)

  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M5"
    list(list(gate "CPI"))
    list(list(bulk "VDD"))
    list(list(source "A0"))
    list(list(drain "X0"))
    1:-2.75 "R0" wpTSI0 minLp)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M6"
    list(list(gate "CPN"))
    list(list(bulk "VSS"))
    list(list(drain "X0"))
    list(list(source "A1"))
    1:-3.75 "R0" wnTSI0 minLn)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M7"
    list(list(gate "D"))
    list(list(bulk "VSS"))
    list(list(drain "A1"))
    list(list(source "VSS"))
    1:-4.75 "R0" wnTSI0 minLn)

  ;;second tri-state inverter stage
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M8"
    list(list(gate "X1"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "A2"))
    3.25:-1 "MY" wpTSI1 minLp)

  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M9"
    list(list(gate "CPN"))
    list(list(bulk "VDD"))
    list(list(source "A2"))
    list(list(drain "X0"))
    3.25:-2 "MY" wpTSI1 minLp)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M10"
    list(list(gate "CPI"))
    list(list(bulk "VSS"))
    list(list(drain "X0"))
    list(list(source "A3"))
    3.25:-3 "MY" wnTSI1 minLn)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M11"
    list(list(gate "X1"))
    list(list(bulk "VSS"))
    list(list(drain "A3"))
    list(list(source "VSS"))
    3.25:-4 "MY" wnTSI1 minLn)

  ;;first inverter stage
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M12"
    list(list(gate "X0"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "X1"))
    2:-5 "R0" wpINV0 minLp)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M13"
    list(list(gate "X0"))
    list(list(bulk "VSS"))
    list(list(drain "X1"))
    list(list(source "VSS"))
    2:-6 "R0" wnINV0 minLn)

  ;;second inverter stage
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M14"
    list(list(gate "X1"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "X2"))
    3.75:-5 "R0" wpINV1 minLp)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M15"
    list(list(gate "X1"))
    list(list(bulk "VSS"))
    list(list(drain "X2"))
    list(list(source "VSS"))
    3.75:-6 "R0" wnINV1 minLn)

  ;;TXGate
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M16"
    list(list(gate "CPN"))
    list(list(bulk "VDD"))
    list(list(source "X2"))
    list(list(drain "X3"))
    5.25:-4.75 "MYR90" wpTX minLp)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M17"
    list(list(gate "CPI"))
    list(list(bulk "VSS"))
    list(list(drain "X2"))
    list(list(source "X3"))
    5.25:-6.25 "R90" wnTX minLn)

  ;;third tri-state inverter stage
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M18"
    list(list(gate "X4"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "A4"))
    6.5:-1 "MY" wpTSI2 minLp)

  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M19"
    list(list(gate "CPI"))
    list(list(bulk "VDD"))
    list(list(source "A4"))
    list(list(drain "X3"))
    6.5:-2 "MY" wpTSI2 minLp)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M20"
    list(list(gate "CPN"))
    list(list(bulk "VSS"))
    list(list(drain "X3"))
    list(list(source "A5"))
    6.5:-3 "MY" wnTSI2 minLn)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M21"
    list(list(gate "X4"))
    list(list(bulk "VSS"))
    list(list(drain "A5"))
    list(list(source "VSS"))
    6.5:-4 "MY" wnTSI2 minLn)

  ;;third inverter stage
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M22"
    list(list(gate "X3"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "X4"))
    6.25:-5 "R0" wpINV2 minLp)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M23"
    list(list(gate "X3"))
    list(list(bulk "VSS"))
    list(list(drain "X4"))
    list(list(source "VSS"))
    6.25:-6 "R0" wnINV2 minLn)

  ;;fourth inverter stage
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "M24"
    list(list(gate "X3"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "Q"))
    7.5:-7 "R0" wpINV3 minLp)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "M25"
    list(list(gate "X3"))
    list(list(bulk "VSS"))
    list(list(drain "Q"))
    list(list(source "VSS"))
    7.5:-8 "R0" wnINV3 minLn)

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;; To create schematic of the Delay Element, which is 8 series inverters,
;;;; with the size of the final stage as input. The chain is sized in an F04 fashion.
;;;; "Backward" sizing is implemented until minimum size is reached and all
;;;; subsequent inverters are minimum sized.
procedure( darCreateDelayElementSchematic(libName cellName FETlibName
	PMOScellName NMOScellName technologyCase @key (wpDriver wpMin)
	(lpDriver lpMin) (wnDriver wnMin) (lnDriver lnMin) (minWp wpMin)
	(minLp lpMin) (minWn wnMin) (minLn lnMin))

  wpDriver = cdfParseFloatString(wpDriver)
  lpDriver = cdfParseFloatString(lpDriver)
  wnDriver = cdfParseFloatString(wnDriver)
  lnDriver = cdfParseFloatString(lnDriver)
  minWp = cdfParseFloatString(minWp)
  minLp = cdfParseFloatString(minLp)
  minWn = cdfParseFloatString(minWn)
  minLn = cdfParseFloatString(minLn)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 1.25
  dy = 3

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 1.5

  ;; OUTPUT
  printf("creating output pin\n")
    foreach(pinName list("OUT")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      x=x-1
    )

  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("IN")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      x=x-1
    )

  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("VSS" "VDD")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      x=x-1
    )

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  ;; FETs
  printf("placing FETs\n")

  x=0
  ;; for loop to create the other inverters
  for( i 1 8

    if(i==1 then
      Xm = "OUT"
      wp = wpDriver
      wn = wnDriver
    else
      Xm = sprintf(nil "X%d" i-1)
      wp = wp
      wn = wn
    )

    if(i==8 then
       Xn = "IN"
    else
       Xn = sprintf(nil "X%d" i)
    )

  ;;check if size of current stage is less than minimum size, if less than,
  ;;make transistor min. size. if greater than, make transistor FO4 less 
  ;;than next stage
  if(wp > minWp then
    wp = wp
  else
    wp = minWp
  )
  if(wn > minWn then
    wn = wn
  else
    wn = minWn
  )

  ;;create rest of inverters
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" sprintf(nil "P%d" i)
    list(list(gate Xn))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain Xm))
    x:0.5 "R0" wp minLp)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" sprintf(nil "N%d" i)
    list(list(gate Xn))
    list(list(bulk "VSS"))
    list(list(drain Xm))
    list(list(source "VSS"))
    x:-0.5 "R0" wn minLn)

  wpi = wp  ;;store current size to local variable
  wni = wn
  wp = wp/4  ;;divide current size by 4 to get FO4 backwards
  wn = wn/4

  x = x - dx
  )

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;;
;;;; To create schematic of 2:1 MUX with "wrapper" script
;;;;
procedure( darCreate2to1MUXSchematic(libName cellName cellName_inverter
	cellName_nand @key (wpNAND wpMin) (wnNAND wnMin) (lpNAND lpMin)
	(lnNAND lnMin) (wpINV wpMin) (wnINV wnMin) (lpINV lpMin) (lnINV lnMin))

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 4
  dy = 3

  ;;; SECTION: SET UP THE PINS
  x = 4
  y = 0.5

  ;; INPUTS
  printf("creating input pins\n")
  foreach(pinName list("VDD" "VSS")
    pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
    x=x+1
  )

  x = 0
  y = 0

  foreach(pinName list("IN0" "IN1" "SELECT")
    pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
    y=y-1.5
  )

  x = 5.25
  y = -0.7

  ;; OUTPUT
  printf("creating output pin\n")
  foreach(pinName list("OUT")
    pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
    y=y-0.5
  )

  ;; NAND gates and inverter
  printf("placing circuit components\n")

  inst = darUvaEceSchematicCreateInstParNand2(cvid libName cellName_nand "IMUX2_NAND0"
		"IN0"
		"SELECTB"
		"OUT0"
		"VDD"
		"VSS"
		0.5:0
		?wp wpNAND ?wn wnNAND ?lp lpNAND ?ln lnNAND)

  inst = darUvaEceSchematicCreateInstParNand2(cvid libName cellName_nand "IMUX2_NAND1"
		"IN1"
		"SELECT"
		"OUT1"
		"VDD"
		"VSS"
		0.5:-1.5
		?wp wpNAND ?wn wnNAND ?lp lpNAND ?ln lnNAND)

  inst = darUvaEceSchematicCreateInstParNand2(cvid libName cellName_nand "IMUX2_NAND2"
		"OUT0"
		"OUT1"
		"OUT"
		"VDD"
		"VSS"
		3:-0.7
		?wp wpNAND ?wn wnNAND ?lp lpNAND ?ln lnNAND)

  inst = darUvaEceSchematicCreateInstParInverter(cvid libName cellName_inverter "IMUX2_INV0"
		"SELECT"
		"SELECTB"
		"VDD"
		"VSS"
		0.5:-3
		?wp wpINV ?wn wnINV ?lp lpINV ?ln lnINV)

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;;
;;;; To create schematic of 4:1 MUX with "wrapper" script
;;;;
procedure( darCreate4to1MUXSchematic(libName cellName cellName_2to1MUX)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET UP THE PINS
  x = 3
  y = 0.5

  ;; SUPPLY NETS
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      x=x+1
    )

  x = 0
  y = 0

  ;;INPUTS
  printf("creating input pins\n")
    foreach(pinName list("IN0" "IN1")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.15
    )

  y = -1.5
    foreach(pinName list("IN2" "IN3")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.15
    )

  ;;SELECT LINES
  pin = UvaEceSchematicCreatePin(cvid "S0" "input" 0:-0.8 "R0")
  pin = UvaEceSchematicCreatePin(cvid "S1" "input" 3:-1 "R0")

  ;; OUTPUT
  printf("creating output pin\n")
  pin = UvaEceSchematicCreatePin(cvid "OUT" "output" 6:-0.7 "R0")

  ;; 2:1 MUXes
  printf("placing 2:1 MUXes\n")

  inst = UvaEceSchematicCreateInst(cvid libName cellName_2to1MUX "symbol" "2MUX0"
		list(list("IN0" "IN0") list("IN1" "IN1") list("SELECT" "S0"))
		list(list("OUT" "OUT0"))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		0.5:0 "R0")

  inst = UvaEceSchematicCreateInst(cvid libName cellName_2to1MUX "symbol" "2MUX1"
		list(list("IN0" "IN2") list("IN1" "IN3") list("SELECT" "S0"))
		list(list("OUT" "OUT1"))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		0.5:-1.5 "R0")

  inst = UvaEceSchematicCreateInst(cvid libName cellName_2to1MUX "symbol" "2MUX2"
		list(list("IN0" "OUT0") list("IN1" "OUT1") list("SELECT" "S1"))
		list(list("OUT" "OUT"))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		3.5:-0.7 "R0")

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;;
;;;; To create schematic of tunable delay element with "wrapper" script
;;;;
procedure( darCreateTunableDelaySchematic(libName cellName cellName_delay cellName_4to1)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 4
  dy = 3

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0.5

  ;; SUPPLY NETS
  printf("creating input pins\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("IN")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  x = 4.25
  y = -1.25

  printf("creating input pins\n")
    foreach(pinName list("SELECT0" "SELECT1")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.25
    )

  x = 7.5
  y = -1

  ;; OUTPUT
  printf("creating output pin\n")
    foreach(pinName list("OUT")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )


  ;; Delay Elements
  printf("placing Delay Elements\n")

  inst = UvaEceSchematicCreateInst(cvid libName cellName_delay "symbol" "DE1"
		list(list("IN" "IN"))
		list(list("OUT" "Delay1"))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		0.75:0.5 "R0")

  x = 3.25

  for(i 2 4
    n = i - 1

    inst = UvaEceSchematicCreateInst(cvid libName cellName_delay "symbol" sprintf(nil "DE%d" i)
		list(list("IN" sprintf(nil "Delay%d" n)))
		list(list("OUT" sprintf(nil "Delay%d" i)))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		x:0.5 "R0")

    x = x + 2.5
  )

  ;; MUX output
  printf("placing MUX\n")

  inst = UvaEceSchematicCreateInst(cvid libName cellName_4to1 "symbol" "MUX0"
		list(list("IN0" "Delay1") list("IN1" "Delay2") list("IN2" "Delay3") list("IN3" "Delay4")
			list("S0" "SELECT0") list("S1" "SELECT1"))
		list(list("OUT" "OUT"))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		5:-1 "R0")

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;;
;;;; To create schematic of the inputs/outputs with "wrapper" script
;;;;
procedure( darCreateIOSchematic(libName cellName cellName_inverter cellName_triState cellName_DFF @key (TSIwpINV wpMin) (TSIwnINV wnMin) (TSIwpEN wpMin) (TSIwnEN wnMin) (TSIlpINV lpMin) (TSIlnINV lnMin) (TSIlpEN lpMin) (TSIlnEN lnMin) (IOwpINV wpMin) (IOwnINV wnMin) (IOlpINV lpMin) (IOlnINV lnMin))

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 4
  dy = 3

  ;;; SECTION: SET UP THE PINS
  x = 0.5
  y = 1

  ;; SUPPLY NETS
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      x=x+0.5
    )

  x = 0
  y = 0.5
  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("OCLK" "SD")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.25
    )

  x = 0
  y = -1

    foreach(pinName list("ICLK" "DIN")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.25
    )

  ;;WEN pin
  pin = UvaEceSchematicCreatePin(cvid "WEN" "input" 0:-3.5 "R0")

  x = 8
  y = -1
  ;; OUTPUT
  printf("creating output pins\n")
    foreach(pinName list("RDWR" "NRDWR")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-1.5
    )

  ;;DOUT pin
  pin = UvaEceSchematicCreatePin(cvid "DOUT" "output" 3:0.5 "R0")

  ;;DFF
  inst = UvaEceSchematicCreateInst(cvid libName cellName_DFF "symbol" "DFF0"
		list(list("CLK" "OCLK") list("D" "SD"))
		list(list("Q" "DOUT"))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		0.75:0.5 "R0")

  inst = UvaEceSchematicCreateInst(cvid libName cellName_DFF "symbol" "DFF1"
		list(list("CLK" "ICLK") list("D" "DIN"))
		list(list("Q" "d"))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		0.75:-1 "R0")

  ;;Inverters
  inst = darUvaEceSchematicCreateInstParInverter(cvid libName cellName_inverter "IOInv1"
		"WEN"
		"NWEN"
		"VDD"
		"VSS"
		0.75:-3.5
		?wp IOwpINV ?wn IOwnINV ?lp IOlpINV ?ln IOlnINV)

  inst = darUvaEceSchematicCreateInstParInverter(cvid libName cellName_inverter "IOInv2"
		"NWEN"
		"WENB"
		"VDD"
		"VSS"
		3.5:-3.5
		?wp IOwpINV ?wn IOwnINV ?lp IOlpINV ?ln IOlnINV)

  inst = darUvaEceSchematicCreateInstParInverter(cvid libName cellName_inverter "IOInv0"
		"d"
		"dB"
		"VDD"
		"VSS"
		3:-1
		?wp IOwpINV ?wn IOwnINV ?lp IOlpINV ?ln IOlnINV)

  ;;Tri-state Inverters
  inst = darUvaEceSchematicCreateInstParTriState(cvid libName cellName_triState "TSI0"
		"dB"
		"NWEN"
		"WENB"
		"RDWR"
		"VDD"
		"VSS"
		5.5:-1
		?wpINV TSIwpINV ?wnINV TSIwnINV ?wpEN TSIwpEN ?wnEN TSIwnEN ?lpINV TSIlpINV ?lnINV TSIlnINV ?lpEN TSIlpEN ?lnEN TSIlnEN)

  inst = darUvaEceSchematicCreateInstParTriState(cvid libName cellName_triState "TSI1"
		"d"
		"NWEN" 
		"WENB"
		"NRDWR"
		"VDD"
		"VSS"
		5.5:-2.5
		?wpINV TSIwpINV ?wnINV TSIwnINV ?wpEN TSIwpEN ?wnEN TSIwnEN ?lpINV TSIlpINV ?lnINV TSIlnINV ?lpEN TSIlpEN ?lnEN TSIlnEN)

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;; To create schematic of a buffer chain, with the number of stages as input.
;;;; The chain is sized in an F04 fashion with the final inverter size given as
;;;; an input by the user. "Backward" sizing is implemented until minimum size is
;;;; reached and all subsequent inverters are minimum sized.
procedure( darCreateBufferChainSchematic(libName cellName FETlibName PMOScellName
	NMOScellName technologyCase stages fanout @key (minWp wpMin) (minLp lpMin) (minWn wnMin)
	(minLn lnMin))

  stages = round(cdfParseFloatString(stages))
  fanout = round(cdfParseFloatString(fanout))
  minWp = cdfParseFloatString(minWp)
  minLp = cdfParseFloatString(minLp)
  minWn = cdfParseFloatString(minWn)
  minLn = cdfParseFloatString(minLn)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 1.25
  dy = 3

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 1.5

  ;; SUPPLY NETS
  printf("creating supply nets\n")
    foreach(pinName list("VSS" "VDD")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      x=x+1
    )

  ;; INPUTS
  printf("creating input pins\n")
  pin=UvaEceSchematicCreatePin(cvid "IN" "input" x:y "R0")
  x=x+1

  ;; OUTPUT
  printf("creating output pin\n")
  pin=UvaEceSchematicCreatePin(cvid "OUT" "output" x:y "R0")

  ;;determining the case of terminals, i.e. upper case or lower case
  terminals = darChooseTerminalCase(technologyCase)

  ;;set the case of terminals
  drain = nth(0 terminals)
  gate = nth(1 terminals)
  source = nth(2 terminals)
  bulk = nth(3 terminals)

  ;; FETs
  printf("placing FETs\n")

  x = 0

  wp = minWp
  wn = minWn

  ;;place first inverter
  if(stages != 0 then
    darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" "P0"
    list(list(gate "IN"))
    list(list(bulk "VDD"))
    list(list(source "VDD"))
    list(list(drain "X1"))
    x:0.5 "R0" wp minLp)

    darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" "N0"
    list(list(gate "IN"))
    list(list(bulk "VSS"))
    list(list(drain "X1"))
    list(list(source "VSS"))
    x:-0.5 "R0" wn minLn)
  else

  )

  x = x + dx
  ;; for loop to create inverters
  for(i 1 stages-1

    if(i==stages-1 then
       Xm = "OUT"
    else
       Xm = sprintf(nil "X%d" i+1)
    )
    Xn = sprintf(nil "X%d" i)

  wp = fanout*wp
  wn = fanout*wn

  ;;create rest of inverters
  darSchematicCreateFETInst(cvid FETlibName PMOScellName "symbol" sprintf(nil "P%d" i)
  list(list(gate Xn))
  list(list(bulk "VDD"))
  list(list(source "VDD"))
  list(list(drain Xm))
  x:0.5 "R0" wp minLp)

  darSchematicCreateFETInst(cvid FETlibName NMOScellName "symbol" sprintf(nil "N%d" i)
  list(list(gate Xn))
  list(list(bulk "VSS"))
  list(list(drain Xm))
  list(list(source "VSS"))
  x:-0.5 "R0" wn minLn)

  x = x + dx
  )

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;;
;;;; To create schematic of 8 word line driver
;;;;
procedure( darCreateWLDriver8Schematic(libName cellName cellName_inverter cellName_nand cellName_and @key (wpInv wpMin) (wnInv wnMin) (lpInv lpMin) (lnInv lnMin) (wpNAND wpMin) (lpNAND lpMin) (wnNAND wnMin) (lnNAND lnMin) (wpANDnand wpMin) (lpANDnand lpMin) (wnANDnand wnMin) (lnANDnand lnMin) (wpANDinv wpMin) (lpANDinv lpMin) (wnANDinv wnMin) (lnANDinv lnMin))

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 3
  dy = 3

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; SUPPLY NETS
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  ;; INPUT
    foreach(pinName list("PRE8_6<0:7>" "PRE5_3<0:7>" "WLclk<0:7>" "A<0:7>" "B<0:7>")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

 ;; WL Pins
    foreach(pinName list(sprintf(nil "WL<0:7>"))
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

  x=0.5
  y=-2
  ;;AND gates
  inst = darUvaEceSchematicCreateInstParAnd2(cvid libName cellName_and "WLDriverAND<0:7>"
		"A<0:7>"
		"B<0:7>"
		"PRE8_3<0:7>"
		"VDD"
		"VSS"
		x:y
		?wpNAND wpANDnand ?wnNAND wnANDnand ?lpNAND lpANDnand ?lnNAND lnANDnand
		?wpINV wpANDinv ?wnINV wnANDinv ?lpINV lpANDinv ?lnINV lnANDinv)

  x=x+dx
  ;;NAND gates
  inst = darUvaEceSchematicCreateInstParNand2(cvid libName cellName_nand "WLDriverNAND<0:7>"
		"PRE8_3<0:7>"
		"WLclk<0:7>"
		"PRE_WL<0:7>"
		"VDD"
		"VSS"
		x:y
		?wp wpNAND ?wn wnNAND ?lp lpNAND ?ln lnNAND)

  x=x+dx
  ;;Inverters
  inst = darUvaEceSchematicCreateInstParInverter(cvid libName cellName_inverter "WLDriverINV<0:7>"
		"PRE_WL<0:7>"
		"WL<0:7>"
		"VDD"
		"VSS"
		x:y
		?wp wpInv ?wn wnInv ?lp lpInv ?ln lnInv)
 
  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;;
;;;; To create schematic of the WL buffers
;;;;
procedure( darCreateWLBufferSchematic(libName cellName R cellName_WLBufferChain)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 5
  dy = 2

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; SUPPLY NETS
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list(sprintf(nil "IN<0:%d>" R-1))
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  ;; OUTPUTS
  printf("creating output pins\n")
    foreach(pinName list(sprintf(nil "OUT<0:%d>" R-1))
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

  y=-1
  x=1

  ;; Buffer chain
  inst = UvaEceSchematicCreateInst(cvid libName cellName_WLBufferChain "symbol"
		sprintf(nil "I_WLBuffer<0:%d>" R-1)
    		list(list("IN" sprintf(nil "IN<0:%d>" R-1)))
		list(list("OUT" sprintf(nil "OUT<0:%d>" R-1)))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		x:y "R0")

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;;
;;;; To create schematic of the PRE WLDriver buffers
;;;;
procedure( darCreatePREWLBufferSchematic(libName cellName cellName_PRE_WLBufferChain)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 4
  dy = 2

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; SUPPLY NETS
  printf("creating supply nets\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("PRE_PRE8_6<0:7>" "PRE_PRE5_3<0:7>" "PRE_WLclk<0:7>")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  ;; OUTPUTS
  printf("creating output pins\n")
    foreach(pinName list("PRE8_6<0:7>" "PRE5_3<0:7>" "WLclk<0:7>")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

  y=0
  x=2

  ;; Buffer chain for 3MSB decoded outputs
  inst = UvaEceSchematicCreateInst(cvid libName cellName_PRE_WLBufferChain "symbol"
		"I8_6Buffer<0:7>"
    		list(list("IN" "PRE_PRE8_6<0:7>"))
		list(list("OUT" "PRE8_6<0:7>"))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		x:y "R0")

  y=y-dy

  ;; Buffer chain for 3 middle decoded outputs
  inst = UvaEceSchematicCreateInst(cvid libName cellName_PRE_WLBufferChain "symbol"
		"I5_3Buffer<0:7>"
    		list(list("IN" "PRE_PRE5_3<0:7>"))
		list(list("OUT" "PRE5_3<0:7>"))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		x:y "R0")

  y=y-dy

  ;; Buffer chain for 3LSB decoded outputs
  inst = UvaEceSchematicCreateInst(cvid libName cellName_PRE_WLBufferChain "symbol"
		"I2_0Buffer<0:7>"
    		list(list("IN" "PRE_WLclk<0:7>"))
		list(list("OUT" "WLclk<0:7>"))
		list(list("VDD" "VDD") list("VSS" "VSS"))
		nil
		x:y "R0")

  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  printf("=== Cell %L schematic has been created! ===\n", cellName)

  jwCheckSchematic(libName cellName)

  jwCreateSymbolFromSchematic(libName cellName)

)

;;;;
;;;; To determine the output node of the row decoder
;;;;
procedure( darChoosePREWLDriverNode(n)
  prog( (preWLDriverNode)

  if( n == 0 then
    node = "no"		;; since n=0, there will be no buffer
  else
    node = "yes"	;; since n!=0, there will be a buffer
  )
  ;;create string for node name
  withBuffer = '("PRE_PRE8_6<0:7>" "PRE_PRE5_3<0:7>" "PRE_WLclk<0:7>")		;; node name with buffer
  withoutBuffer = '("PRE8_6<0:7>" "PRE5_3<0:7>" "WLclk<0:7>")			;; node name without buffer

  ;;determine which node name to use
  preWLDriverNode = case(node
      ("yes" withBuffer)
      ("no" withoutBuffer)
  )

  return(preWLDriverNode)

  )
)

;;;;
;;;; To determine the output node of the WLDriver
;;;;
procedure( darChoosePREWLNode(k R)
  prog( (preWLNode)

  if( k == 0 then
    node = "no"		;; since k=0, there will be no buffer
  else
    node = "yes"	;; since k!=0, there will be a buffer
  )
  ;;create string for node name
  withBuffer = sprintf(nil "PRE_WL<0:%d>" R-1)		;; node name with buffer
  withoutBuffer = sprintf(nil "WL<0:%d>" R-1)		;; node name without buffer

  ;;determine which node name to use
  preWLNode = case(node
      ("yes" withBuffer)
      ("no" withoutBuffer)
  )

  return(preWLNode)

  )
)




;;;;
;;;; Procedure for testing functions
;;;;
procedure( darTestSchematic(libName cellName FETlibName PMOScellName NMOScellName \
	technologyCaseCase @key (wp 180.0n) (wn 90.0n) (lp 50.0n) (ln 50.0n))
  prog( (terminals drain gate source bulk)

  ;;instantiate a new schematic
  cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
  UvaEceDeleteObjectsSchematic(cvid)

  ;;; SECTION: SET schematic params
  dx = 4
  dy = 3

  ;;; SECTION: SET UP THE PINS
  x = 0
  y = 0

  ;; SUPPLY NETS
  printf("creating input pins\n")
    foreach(pinName list("VDD" "VSS")
      pin=UvaEceSchematicCreatePin(cvid pinName "inputOutput" x:y "R0")
      y=y-0.5
    )

  ;; INPUTS
  printf("creating input pins\n")
    foreach(pinName list("IN" "TRIN" "TRIP")
      pin=UvaEceSchematicCreatePin(cvid pinName "input" x:y "R0")
      y=y-0.5
    )

  ;; OUTPUT
  printf("creating output pin\n")
    foreach(pinName list("OUT")
      pin=UvaEceSchematicCreatePin(cvid pinName "output" x:y "R0")
      y=y-0.5
    )

/*
  darUvaEceSchematicCreateInstParInverter(cvid libName "inverter" "I200"
  "IND" "INDB1" "VDD" "VSS" 0.75:-1 ?wp 227n);; ?wn 156n ?lp 56n ?ln 63n )


  darUvaEceSchematicCreateInstParNand2(cvid libName "NAND2" "I202"
  "A<0>" "B<0>" "OUTA" "VDD" "VSS" 0.75:-3 ?wp 300n)

  darUvaEceSchematicCreateInstParAnd2(cvid libName "AND2" "I203"
  "A<1>" "B<1>" "OUTB" "VDD" "VSS" 0.75:-4.5 ?wpNAND 70n ?lnINV 56n)
*/

  darUvaEceSchematicCreateInstParTriState(cvid libName "TSI" "symbol" "TSI0"
  list(list("IN" "IN") list("TRIP" "TRIP") list("TRIN" "TRIN"))
  list(list("OUT" "OUT"))
  list(list("VDD" "VDD") list("VSS" "VSS"))
  nil
  1:-2)


  ;;save schematic and close schematic window
  dbSave(cvid)
  dbClose(cvid)

  jwCheckSchematic(libName cellName)

  )
)







