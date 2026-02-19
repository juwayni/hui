import nimui/layouts/layout
import std/tables
import std/strutils

type
  LayoutFactory* = object

var gLayoutMap = initTable[string, proc(): Layout {.gcsafe.}]()

proc register*(name: string, factory: proc(): Layout {.gcsafe.}) =
  gLayoutMap[name.toLowerAscii()] = factory

proc createFromName*(name: string): Layout =
  let key = name.toLowerAscii()
  if gLayoutMap.hasKey(key):
    return gLayoutMap[key]()
  return nil
