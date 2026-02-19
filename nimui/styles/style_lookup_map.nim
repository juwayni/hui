import nimui/util/variant
import std/tables

type
  StyleLookupMap* = ref object
    valueMap: Table[string, Variant]

var styleLookupMapInstance: StyleLookupMap

proc instance*(): StyleLookupMap =
  if styleLookupMapInstance == nil:
    new styleLookupMapInstance
    styleLookupMapInstance.valueMap = initTable[string, Variant]()
  return styleLookupMapInstance

proc set*(self: StyleLookupMap, name: string, value: Variant) =
  self.valueMap[name] = value

proc get*(self: StyleLookupMap, name: string): Variant =
  return self.valueMap.getOrDefault(name, toVariant(nil))

proc remove*(self: StyleLookupMap, name: string) =
  self.valueMap.del(name)
