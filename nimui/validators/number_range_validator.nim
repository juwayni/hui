import nimui/validators/number_validator

type
  NumberRangeValidator* = ref object of NumberValidator

proc newNumberRangeValidator*(): NumberRangeValidator =
  new result
  result.initValidator()
