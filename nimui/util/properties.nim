import std/tables

type
  Properties* = ref object
    map: TableRef[string, string]

proc newProperties*(): Properties =
  new result
  result.map = newTable[string, string]()
