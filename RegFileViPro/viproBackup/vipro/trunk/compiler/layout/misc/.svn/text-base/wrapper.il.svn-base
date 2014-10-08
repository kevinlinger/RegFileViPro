/* This script tests the "wrapper" procedures found in darSchematic.il

By Daniel Reyno, 12.1.10

*/


load("UvaEceSchematic.il")
load("darSchematic.il")

  libName="ViPro"
  FETlibName="cmos065"
  technology="ST65"


;;;;;;;;;;;;;;;;create schematic for Tunable Delay Element
  ;;define the cellName
  cellName="TunableDelay"

  ;;define transistor type; i.e. VTH/VTL/VTG
  PMOScellName="psvtlp"
  NMOScellName="nsvtlp"

  ;;call procedure to create test schematic
  darTestTunableDelaySchematic(libName cellName FETlibName PMOScellName NMOScellName technology)

;;;;;;;;;;;;;;;;create schematic for I/O circuit
  ;;define the cellName
  cellName="IOBlock"

  ;;define transistor type; i.e. VTH/VTL/VTG
  PMOScellName="psvtlp"
  NMOScellName="nsvtlp"

  ;;call procedure to create test schematic
  ;darTestIOSchematic(libName cellName FETlibName PMOScellName NMOScellName technology)

;;;;;;;;;;;;;;;;create schematic for Timing Block
  ;;define the cellName
  cellName="TimingBlock"

  ;;define transistor type; i.e. VTH/VTL/VTG
  PMOScellName="psvtlp"
  NMOScellName="nsvtlp"

  ;;call procedure to create test schematic
  darTestTimingBlockSchematic(libName cellName FETlibName PMOScellName NMOScellName technology)




