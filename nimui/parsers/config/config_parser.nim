import ../../util/generic_config, tables

type
  ConfigParser* = ref object of RootObj

proc newConfigParser*(): ConfigParser =
  ConfigParser()

method parse*(self: ConfigParser, data: string, defines: Table[string, string]): GenericConfig {.base.} =
  raise newException(CatchableError, "Config parser not implemented!")

var gParsers: Table[string, proc(): ConfigParser]

proc register*(extension: string, creator: proc(): ConfigParser) =
  gParsers[extension] = creator

proc get*(extension: string): ConfigParser =
  if not gParsers.hasKey(extension): return nil
  return gParsers[extension]()
