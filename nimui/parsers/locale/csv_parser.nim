import ./key_value_parser, ../../locale/locale_parser

type
  CSVParser* = ref object of KeyValueParser

proc newCSVParser*(): LocaleParser =
  let res = CSVParser()
  res.parserSeparator = ";"
  res.parserCommentString = "#"
  res.parserStrict = false
  res.parserLineFeed = "\n"
  return res

register("csv", newCSVParser)
