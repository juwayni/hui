import tables

type
  AssetPlugin* = ref object of RootObj
    props: TableRef[string, string]

proc newAssetPlugin*(): AssetPlugin =
  new result
  result.props = nil

method invoke*(self: AssetPlugin, asset: any): any {.base.} =
  return asset

method setProperty*(self: AssetPlugin, name: string, value: string) {.base.} =
  if self.props == nil:
    self.props = newTable[string, string]()
  self.props[name] = value

method getProperty*(self: AssetPlugin, name: string, defaultValue: string = ""): string {.base.} =
  if self.props == nil:
    return defaultValue
  return self.props.getOrDefault(name, defaultValue)
