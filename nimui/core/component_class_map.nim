import tables, strutils

type
  ComponentClassMap* = ref object
    mapInternal*: TableRef[string, string]

var instanceInternal: ComponentClassMap

proc instance*(): ComponentClassMap =
  if instanceInternal == nil:
    instanceInternal = ComponentClassMap(mapInternal: newTable[string, string]())
  return instanceInternal

proc get*(alias: string): string =
  let a = alias.replace("-", "").toLowerAscii()
  return instance().mapInternal.getOrDefault(a)

proc register*(alias: string, className: string) =
  instance().mapInternal[alias.toLowerAscii()] = className

proc registerClass*(className: string, alias: string = "") =
  var a = alias
  if a == "":
    var parts = className.split('.')
    a = parts.pop().toLowerAscii()
  register(a, className)

proc list*(): seq[string] =
  var l: seq[string] = @[]
  for k in instance().mapInternal.keys:
    l.add(k)
  return l

proc clear*() =
  instance().mapInternal = newTable[string, string]()

proc hasClass*(className: string): bool =
  for v in instance().mapInternal.values:
    if v == className:
      return true
  return false
