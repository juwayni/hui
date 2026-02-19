import ../../locale/locale_parser, tables, strutils

type
  KeyValueParser* = ref object of LocaleParser
    parserSeparator*: string
    parserCommentString*: string
    parserLineFeed*: string
    parserStrict*: bool

proc newKeyValueParser*(): KeyValueParser =
  KeyValueParser(
    parserSeparator: "",
    parserCommentString: "",
    parserLineFeed: "\n",
    parserStrict: false
  )

method parse*(self: KeyValueParser, data: string): Table[string, string] =
  if self.parserSeparator == "":
    raise newException(CatchableError, "parserSeparator needs implementation")

  var result = initTable[string, string]()
  let lines = data.split(self.parserLineFeed)
  for line in lines:
    let trimmed = line.strip()
    if trimmed.len == 0 or (self.parserCommentString != "" and trimmed.startsWith(self.parserCommentString)):
      continue

    let separatorIdx = trimmed.find(self.parserSeparator)
    if separatorIdx == -1:
      if self.parserStrict:
        raise newException(CatchableError, "Locale parser: Invalid line " & trimmed & ". Missing separator " & self.parserSeparator)
      else:
        continue

    let key = trimmed[0 ..< separatorIdx].strip()
    let content = trimmed[separatorIdx + 1 .. ^1].strip()
    result[key] = content

  return result
