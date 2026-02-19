type
  Formats* = ref object
    decimalSeparator*: string
    thousandsSeparator*: string
    dateFormat*: string
    timeFormat*: string
    dateTimeFormat*: string

proc newFormats*(): Formats =
  new result
  result.decimalSeparator = "."
  result.thousandsSeparator = ","
  result.dateFormat = "%Y-%m-%d"
  result.timeFormat = "%H:%M:%S"
  result.dateTimeFormat = "%Y-%m-%d %H:%M:%S"

var gFormats* = newFormats()
