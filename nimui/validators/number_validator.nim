import nimui/validators/validators
import std/options

type
  NumberValidator* = ref object of PatternValidator

proc newNumberValidator*(): NumberValidator =
  new result
  result.initValidator()
