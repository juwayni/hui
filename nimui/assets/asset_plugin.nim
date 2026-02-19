import std/tables
import nimui/util/variant

type
  AssetPlugin* = ref object of RootObj
    props: Table[string, string]

proc newAssetPlugin*(): AssetPlugin =
  new result
  result.props = initTable[string, string]()

method invoke*(self: AssetPlugin, asset: Variant): Variant {.base.} =
  return asset

method setProperty*(self: AssetPlugin, name: string, value: string) {.base.} =
  self.props[name] = value

method getProperty*(self: AssetPlugin, name: string, defaultValue: string = ""): string {.base.} =
  return self.props.getOrDefault(name, defaultValue)
