import tables

type
  LocaleParser* = ref object of RootObj

method parse*(self: LocaleParser, data: string): TableRef[string, string] {.base.} =
  raise newException(Exception, "Locale parser not implemented!")

var parserMap = newTable[string, proc(): LocaleParser]()

proc register*(extension: string, factory: proc(): LocaleParser) =
  parserMap[extension] = factory

proc get*(extension: string): LocaleParser =
  if parserMap.hasKey(extension):
    return parserMap[extension]()
  raise newException(Exception, "No locale parser found for " & extension)
