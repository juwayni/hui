import ./resolvers/resource_resolver, ./component_info, tables, strutils, math, std/options

type
  ComponentParser* = ref object of RootObj
    resourceResolver*: ResourceResolver

proc newComponentParser*(): ComponentParser =
  ComponentParser()

method parse*(self: ComponentParser, data: string, resourceResolver: ResourceResolver = nil, fileName: string = ""): ComponentInfo {.base.} =
  raise newException(CatchableError, "Component parser not implemented!")

var gParsers: Table[string, proc(): ComponentParser]

proc register*(extension: string, creator: proc(): ComponentParser) =
  gParsers[extension] = creator

proc get*(extension: string): ComponentParser =
  if not gParsers.hasKey(extension):
    raise newException(CatchableError, "No component parser found for " & extension)
  return gParsers[extension]()

var gNextId = 0
proc nextId*(prefix: string = "component"): string =
  let s = prefix & $gNextId
  inc gNextId
  return s

proc parseFloatSafe*(value: string): float =
  try:
    return parseFloat(value)
  except:
    return 0.0

proc isPercentage*(value: string): bool =
  return value.endsWith("%")
