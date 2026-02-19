import ./module
import tables

type
  ModuleParser* = ref object of RootObj

method parse*(self: ModuleParser, data: string, defines: TableRef[string, string], context: string = ""): Module {.base.} =
  raise newException(Exception, "Module parser not implemented!")

var parserMap = newTable[string, proc(): ModuleParser]()

proc register*(extension: string, factory: proc(): ModuleParser) =
  parserMap[extension] = factory

proc get*(extension: string): ModuleParser =
  if parserMap.hasKey(extension):
    return parserMap[extension]()
  return nil
