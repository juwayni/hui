import tables, nimui/util/variant

type
  ValidatorInfo* = ref object
    `type`*: string
    properties*: TableRef[string, Variant]

proc newValidatorInfo*(): ValidatorInfo =
  ValidatorInfo(properties: newTable[string, Variant]())
