/* This procedure creates the functions for placing
parameterized gates

Procedures adopted from "jwBasicSchematic.il"

By Daniel Reyno, 02-04-2011

*/

;;;;
;;;; Create instance of a parameterized inverter
;;;;
procedure(darUvaEceSchematicCreateInstParInverter(cvid libName cellName Iname in out VDD VSS location @key (wp wpMin) (wn wnMin) (lp lpMin) (ln lnMin) (m 1))
  prog((inst mstr)

  ;; need to convert the strings to floats
  wp = cdfParseFloatString(wp)
  wn = cdfParseFloatString(wn)
  lp = cdfParseFloatString(lp)
  ln = cdfParseFloatString(ln)

  if(Iname != nil then
    inst = UvaEceSchematicCreateInst(cvid libName cellName "symbol"
        Iname
        list(list("IN" in))
        list(list("OUT" out))
        list(list("VDD" VDD) list("VSS" VSS))
        nil
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

;;;;
;;;; Create instance of a parameterized 2 input NAND gate
;;;;
procedure(darUvaEceSchematicCreateInstParNand2(cvid libName cellName Iname inA inB out VDD VSS location @key (wp wpMin) (wn wnMin) (ln lnMin) (lp lpMin) (m 1))
  prog((inst mstr)

  ;; need to convert the strings to floats
  wp = cdfParseFloatString(wp)
  wn = cdfParseFloatString(wn)
  lp = cdfParseFloatString(lp)
  ln = cdfParseFloatString(ln)

  if(Iname != nil then
    inst = UvaEceSchematicCreateInst(cvid libName cellName "symbol"
        Iname
        list(list("INA" inA)
             list("INB" inB))
        list(list("OUT" out))
        list(list("VDD" VDD)
             list("VSS" VSS))
        nil
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

;;;;
;;;; Create instance of a parameterized 2 input AND gate
;;;;
procedure(darUvaEceSchematicCreateInstParAnd2(cvid libName cellName Iname inA inB out VDD VSS location @key (wpNAND wpMin) (wnNAND wnMin) (wpINV wpMin) (wnINV wnMin) (lpNAND lpMin) (lnNAND lnMin) (lpINV lpMin) (lnINV lnMin) (m 1))
  prog((inst mstr)

  ;; need to convert the strings to floats
  wpNAND = cdfParseFloatString(wpNAND)
  wnNAND = cdfParseFloatString(wnNAND)
  wpINV = cdfParseFloatString(wpINV)
  wnINV = cdfParseFloatString(wnINV)
  lpNAND = cdfParseFloatString(lpNAND)
  lnNAND = cdfParseFloatString(lnNAND)
  lpINV = cdfParseFloatString(lpINV)
  lnINV = cdfParseFloatString(lnINV)

  if(Iname != nil then
    inst = UvaEceSchematicCreateInst(cvid libName cellName "symbol"
        Iname
        list(list("INA" inA)
	     list("INB" inB))
        list(list("OUT" out))
        list(list("VDD" VDD)
	     list("VSS" VSS))
        nil
        location "R0")

    /* now add the properties */
    if(inst != nil then
        if(wpNAND !=nil && wpNAND > 0 then
           dbCreateProp(inst "wpNAND" "string" sprintf(nil "%L" wpNAND)))
        if(wpINV !=nil && wpINV > 0 then
           dbCreateProp(inst "wpINV" "string" sprintf(nil "%L" wpINV)))
        if(wnNAND != nil && wnNAND > 0 then
           dbCreateProp(inst "wnNAND" "string" sprintf(nil "%L" wnNAND)))
        if(wnINV != nil && wnINV > 0 then
           dbCreateProp(inst "wnINV" "string" sprintf(nil "%L" wnINV)))
        if(lpNAND !=nil && lpNAND > 0 then
           dbCreateProp(inst "lpNAND" "string" sprintf(nil "%L" lpNAND)))
        if(lnNAND !=nil && lnNAND > 0 then
           dbCreateProp(inst "lnNAND" "string" sprintf(nil "%L" lnNAND)))
        if(lpINV !=nil && lpINV > 0 then
           dbCreateProp(inst "lpINV" "string" sprintf(nil "%L" lpINV)))
        if(lnINV !=nil && lnINV > 0 then
           dbCreateProp(inst "lnINV" "string" sprintf(nil "%L" lnINV)))
        if(m !=nil && m > 0 then
           dbCreateProp(inst "m" "string" sprintf(nil "%L" m)))
        )
    )
    return(inst)
  )
)

;;;;
;;;; Create instance of a parameterized 2 input NOR gate
;;;;
procedure(darUvaEceSchematicCreateInstParNor2(cvid libName cellName Iname inA inB out VDD VSS location @key (wp wpMin) (wn wnMin) (ln lnMin) (lp lpMin) (m 1))
  prog((inst mstr)

  ;; need to convert the strings to floats
  wp = cdfParseFloatString(wp)
  wn = cdfParseFloatString(wn)
  lp = cdfParseFloatString(lp)
  ln = cdfParseFloatString(ln)

  if(Iname != nil then
    inst = UvaEceSchematicCreateInst(cvid libName cellName "symbol"
        Iname
        list(list("INA" inA)
             list("INB" inB))
        list(list("OUT" out))
        list(list("VDD" VDD)
             list("VSS" VSS))
        nil
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

;;;;
;;;; Create instance of a parameterized buffer
;;;;
procedure(darUvaEceSchematicCreateInstParBuf(cvid libName cellName Iname in out VDD VSS location @key (wp1 wpMin) (wn1 wnMin) (wp2 wpMin) (wn2 wnMin) (lp1 lpMin) (ln1 lnMin) (lp2 lpMin) (ln2 lnMin) (m 1))
  prog((inst mstr)

  ;; need to convert the strings to floats
  wp1 = cdfParseFloatString(wp1)
  wn1 = cdfParseFloatString(wn1)
  lp1 = cdfParseFloatString(lp1)
  ln1 = cdfParseFloatString(ln1)
  wp2 = cdfParseFloatString(wp2)
  wn2 = cdfParseFloatString(wn2)
  lp2 = cdfParseFloatString(lp2)
  ln2 = cdfParseFloatString(ln2)

  if(Iname != nil then
    inst = UvaEceSchematicCreateInst(cvid libName cellName "symbol"
        Iname
        list(list("IN" in))
        list(list("OUT" out))
        list(list("VDD" VDD) list("VSS" VSS))
        nil
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
        if(lp1 !=nil && lp1 > 0 then
           dbCreateProp(inst "lp1" "string" sprintf(nil "%L" lp1)))
        if(ln1 !=nil && ln1 > 0 then
           dbCreateProp(inst "ln1" "string" sprintf(nil "%L" ln1)))
        if(lp2 !=nil && lp2 > 0 then
           dbCreateProp(inst "lp2" "string" sprintf(nil "%L" lp2)))
        if(ln2 !=nil && ln2 > 0 then
           dbCreateProp(inst "ln2" "string" sprintf(nil "%L" ln2)))
        if(m !=nil && m > 0 then
           dbCreateProp(inst "m" "string" sprintf(nil "%L" m)))
        )
    )
    return(inst)
  )
)

;;;;
;;;; Create instance of a parameterized tri-state inverter
;;;;
procedure(darUvaEceSchematicCreateInstParTriState(cvid libName cellName Iname in triP triN out VDD VSS location @key (wpINV wpMin) (wnINV wnMin) (wpEN wpMin) (wnEN wnMin) (lpINV lpMin) (lnINV lnMin) (lpEN lpMin) (lnEN lnMin) (m 1))
  prog((inst mstr)

  ;; need to convert the strings to floats
  wpINV = cdfParseFloatString(wpINV)
  wnINV = cdfParseFloatString(wnINV)
  lpINV = cdfParseFloatString(lpINV)
  lnINV = cdfParseFloatString(lnINV)
  wpEN = cdfParseFloatString(wpEN)
  wnEN = cdfParseFloatString(wnEN)
  lpEN = cdfParseFloatString(lpEN)
  lnEN = cdfParseFloatString(lnEN)

  if(Iname != nil then
    inst = UvaEceSchematicCreateInst(cvid libName cellName "symbol"
        Iname
        list(list("IN" in) list("TRIP" triP) list("TRIN" triN))
        list(list("OUT" out))
        list(list("VDD" VDD) list("VSS" VSS))
        nil
        location "R0")

    /* now add the properties */
    if(inst != nil then
        if(wpINV !=nil && wpINV > 0 then
           dbCreateProp(inst "wpINV" "string" sprintf(nil "%L" wpINV)))
        if(wpEN !=nil && wpEN > 0 then
           dbCreateProp(inst "wpEN" "string" sprintf(nil "%L" wpEN)))
        if(wnEN != nil && wnEN > 0 then
           dbCreateProp(inst "wnEN" "string" sprintf(nil "%L" wnEN)))
        if(wnINV != nil && wnINV > 0 then
           dbCreateProp(inst "wnINV" "string" sprintf(nil "%L" wnINV)))
        if(lpINV !=nil && lpINV > 0 then
           dbCreateProp(inst "lpINV" "string" sprintf(nil "%L" lpINV)))
        if(lpEN !=nil && lpEN > 0 then
           dbCreateProp(inst "lpEN" "string" sprintf(nil "%L" lpEN)))
        if(lnEN !=nil && lnEN > 0 then
           dbCreateProp(inst "lnEN" "string" sprintf(nil "%L" lnEN)))
        if(lnINV !=nil && lnINV > 0 then
           dbCreateProp(inst "lnINV" "string" sprintf(nil "%L" lnINV)))
        if(m !=nil && m > 0 then
           dbCreateProp(inst "m" "string" sprintf(nil "%L" m)))
        )
    )
    return(inst)
  )
)
