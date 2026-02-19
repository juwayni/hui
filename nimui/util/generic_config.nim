import std/tables

type
  GenericConfig* = ref object
    values: TableRef[string, string]

proc newGenericConfig*(): GenericConfig =
  new result
  result.values = newTable[string, string]()
