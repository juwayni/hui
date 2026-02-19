import ./key_value_parser, ../../locale/locale_parser

type
  TSVParser* = ref object of KeyValueParser

proc newTSVParser*(): LocaleParser =
  let res = TSVParser()
  res.parserSeparator = "\t"
  res.parserCommentString = "#"
  res.parserStrict = false
  res.parserLineFeed = "\n"
  return res

register("tsv", newTSVParser)
