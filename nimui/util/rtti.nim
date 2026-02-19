import tables, strutils

type
  RTTIProperty* = object
    propertyName*: string
    propertyType*: string

  RTTIEntry* = object
    superClass*: string
    properties*: Table[string, RTTIProperty]

var classInfo*: Table[string, RTTIEntry]

proc addClassProperty*(className, propertyName: string, propertyType: string) =
  let cn = className.toLowerAscii()
  let pn = propertyName.toLowerAscii()
  var pt = propertyType.toLowerAscii()

  if pt == "null<bool>": pt = "bool"
  elif pt == "null<int>": pt = "int"
  elif pt == "null<float>": pt = "float"
  elif pt == "null<color>": pt = "color"

  if not classInfo.hasKey(cn):
    classInfo[cn] = RTTIEntry(properties: initTable[string, RTTIProperty]())

  classInfo[cn].properties[pn] = RTTIProperty(propertyName: pn, propertyType: pt)

proc setSuperClass*(className, superClassName: string) =
  let cn = className.toLowerAscii()
  var sn = superClassName.toLowerAscii()
  if sn.startsWith("."): sn = sn[1..^1]

  if not classInfo.hasKey(cn):
    classInfo[cn] = RTTIEntry(properties: initTable[string, RTTIProperty]())

  var entry = classInfo[cn]
  entry.superClass = sn
  classInfo[cn] = entry

proc getClassInfo*(className: string): RTTIEntry =
  return classInfo.getOrDefault(className.toLowerAscii())

proc hasSuperClass*(className, superClassName: string): bool =
  let cn = className.toLowerAscii()
  var sn = superClassName.toLowerAscii()
  if sn.startsWith("."): sn = sn[1..^1]

  if cn == sn: return true

  var current = cn
  while true:
    if not classInfo.hasKey(current): return false
    let entry = classInfo[current]
    if entry.superClass == "": return false
    if entry.superClass == sn: return true
    current = entry.superClass
  return false

proc getClassProperty*(className, propertyName: string): RTTIProperty =
  let cn = className.toLowerAscii()
  let pn = propertyName.toLowerAscii()

  if not classInfo.hasKey(cn): return RTTIProperty()

  let entry = classInfo[cn]
  if entry.properties.hasKey(pn):
    return entry.properties[pn]

  if entry.superClass != "":
    return getClassProperty(entry.superClass, propertyName)

  return RTTIProperty()
