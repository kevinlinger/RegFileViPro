/* This procedure creates the additional functions for schematic 
in MITLL-180-XLP PDK

By Jiajing Wang, 02-10-2009

*/

load("./skill/UvaEceSchematic.il")

;;;;
;;;; To create instance of inv_X with specific size
;;;;
procedure( jwSchematicCreateInstInv_X(cvid Iname location in out VDD VSS pw nw l m )
  prog((inst mstr)
  if(Iname != nil then
    inst = UvaEceSchematicCreateInst(cvid "subvtsram180" "jw_inv_X" "symbol" 
	Iname
	list(list("A" in))
	list(list("Y" out))
        list(list("VDD" VDD))
        list(list("VSS" VSS))
        location "R0")
    
    /* now add the properties */
    if(inst != nil then
	if(pw > 0 then
	   dbCreateProp(inst "wp" "string" sprintf(nil "%L" pw)))
	if(nw > 0 then
	   dbCreateProp(inst "wn" "string" sprintf(nil "%L" nw)))
	if(l > 0 then
	   dbCreateProp(inst "ln" "string" sprintf(nil "%L" l))
	   dbCreateProp(inst "lp" "string" sprintf(nil "%L" l)))
	if(m > 0 then
	   dbCreateProp(inst "mfactor" "string" sprintf(nil "%L" m)))
	)
    ) 
    return(inst)
  )
)

procedure(UvaEceSchematicCreateInstParInverter(cvid libName cellName Iname location in out VDD VSS @key (lp 0.06) (wp 0.2) (ln 0.06) (wn 0.2) (m 1))
  prog((inst mstr)
  if(Iname != nil then
    inst = UvaEceSchematicCreateInst(cvid libName cellName "symbol"
        Iname
        list(list("IN" in))
        list(list("OUT" out))
        list(list("VDD" VDD))
        list(list("VSS" VSS))
        location "R0")

    /* now add the properties */
    if(inst != nil then
        if(wp !=nil && wp > 0 then
           dbCreateProp(inst "wp" "string" sprintf(nil "%L" wp)))
        if(wn != nil && wn > 0 then
           dbCreateProp(inst "wn" "string" sprintf(nil "%L" wn)))
        if(lp !=nil && lp > 0 then
           dbCreateProp(inst "lp" "string" sprintf(nil "%L" lp)))
        if(ln !=nil && ln > 0 then
           dbCreateProp(inst "ln" "string" sprintf(nil "%L" ln)))
        if(m !=nil && m > 0 then
           dbCreateProp(inst "m" "string" sprintf(nil "%L" m)))
        )
    )
    return(inst)
  )
)

procedure(UvaEceSchematicCreateInstParNand2(cvid libName cellName Iname location intop inbot out VDD VSS @key (lp 0.06) (wp 0.20) (ln 0.060) (wn 0.20) (m 1))
  prog((inst mstr)
  if(Iname != nil then
    inst = UvaEceSchematicCreateInst(cvid libName cellName "symbol"
        Iname
        list(list("INbot" inbot)
             list("INtop" intop))
        list(list("OUT" out))
        list(list("VDD" VDD))
        list(list("VSS" VSS))
        location "R0")

    /* now add the properties */
    if(inst != nil then
        if(wp !=nil && wp > 0 then
           dbCreateProp(inst "wp" "string" sprintf(nil "%L" wp)))
        if(wn != nil && wn > 0 then
           dbCreateProp(inst "wn" "string" sprintf(nil "%L" wn)))
        if(lp !=nil && lp > 0 then
           dbCreateProp(inst "lp" "string" sprintf(nil "%L" lp)))
        if(ln !=nil && ln > 0 then
           dbCreateProp(inst "ln" "string" sprintf(nil "%L" ln)))
        if(m !=nil && m > 0 then
           dbCreateProp(inst "m" "string" sprintf(nil "%L" m)))
        )
    )
    return(inst)
  )
)

procedure(UvaEceSchematicCreateInstParAnd2(cvid libName cellName Iname location intop inbot out VDD VSS @key (wp1 0.2) (wn1 0.2) (wp2 0.2) (wn2 0.2) (lp 0.06) (ln 0.06) (m 1))
  prog((inst mstr)
  if(Iname != nil then
    inst = UvaEceSchematicCreateInst(cvid libName cellName "symbol"
        Iname
        list(list("INbot" inbot)
	     list("INtop" intop))
        list(list("OUT" out))
        list(list("VDD" VDD))
        list(list("VSS" VSS))
        location "R0")

    /* now add the properties */
    if(inst != nil then
        if(wp1 !=nil && wp1 > 0 then
           dbCreateProp(inst "wp1" "string" sprintf(nil "%L" wp1)))
        if(wp2 !=nil && wp2 > 0 then
           dbCreateProp(inst "wp2" "string" sprintf(nil "%L" wp2)))
        if(wn1 != nil && wn1 > 0 then
           dbCreateProp(inst "wn1" "string" sprintf(nil "%L" wn1)))
        if(wn2 != nil && wn2 > 0 then
           dbCreateProp(inst "wn2" "string" sprintf(nil "%L" wn2)))
        if(lp !=nil && lp > 0 then
           dbCreateProp(inst "lp" "string" sprintf(nil "%L" lp)))
        if(ln !=nil && ln > 0 then
           dbCreateProp(inst "ln" "string" sprintf(nil "%L" ln)))
        if(m !=nil && m > 0 then
           dbCreateProp(inst "m" "string" sprintf(nil "%L" m)))
        )
    )
    return(inst)
  )
)

procedure(UvaEceSchematicCreateInstParBuf(cvid libName cellName Iname location in out VDD VSS @key (wp1
 0.2) (wn1 0.2) (wp2 0.2) (wn2 0.2) (lp 0.06) (ln 0.06) (m 1))
  prog((inst mstr)
  if(Iname != nil then
    inst = UvaEceSchematicCreateInst(cvid libName cellName "symbol"
        Iname
        list(list("IN" in))
        list(list("OUT" out))
        list(list("VDD" VDD))
        list(list("VSS" VSS))
        location "R0")

    /* now add the properties */
    if(inst != nil then
        if(wp1 !=nil && wp1 > 0 then
           dbCreateProp(inst "wp1" "string" sprintf(nil "%L" wp1)))
        if(wp2 !=nil && wp2 > 0 then
           dbCreateProp(inst "wp2" "string" sprintf(nil "%L" wp2)))
        if(wn1 != nil && wn1 > 0 then
           dbCreateProp(inst "wn1" "string" sprintf(nil "%L" wn1)))
        if(wn2 != nil && wn2 > 0 then
           dbCreateProp(inst "wn2" "string" sprintf(nil "%L" wn2)))
        if(lp !=nil && lp > 0 then
           dbCreateProp(inst "lp" "string" sprintf(nil "%L" lp)))
        if(ln !=nil && ln > 0 then
           dbCreateProp(inst "ln" "string" sprintf(nil "%L" ln)))
        if(m !=nil && m > 0 then
           dbCreateProp(inst "m" "string" sprintf(nil "%L" m)))
        )
    )
    return(inst)
  )
)


;;;;-----------------------------------
;;;; Create Symbol
procedure(jwCreateSymbolFromSchematic(libName cellName)     

  prog((cvid pinList)

    cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
    pinList = schSchemToPinList(libName cellName "schematic")

;;println(pinList)

    schPinListToSymbolGen(libName cellName "symbol" pinList)

    dbSave(cvid)
    dbClose(cvid)

  )
)


;;;;-----------------------------------
;;;; Check Schematic
procedure(jwCheckSchematic(libName cellName)     

  prog((cvid errs nErrs nWarns)
    
    cvid = dbOpenCellViewByType(libName cellName "schematic" "schematic" "a")
    errs = schCheck( cvid )
    nErrs = car( errs )
    nWarns = cadr( errs )
    printf("Schematic of %L has been checked." cellName)
    if( nErrs>0 then
      printf("Schematic of %L has %d errors." cellName nErrs)
    )
    if( nWarns>0 then
      printf("Schematic of %L has %d warnings." cellName nWarns)
    )
    printf("\n")

    dbSave(cvid)
    dbClose(cvid)

  )

)


;;;;-----------------------------------
;;;; Craete Netlist from Schematic
procedure(jwCreateNetlistFromSchematic(libName cellName)     

  prog((libName cellName)
    
    simulator( 'spectre )
    printf("========Enter Debug===== ")
    design( libName cellName "schematic" )
    createNetlist( ?recreateAll t )

  )

)
