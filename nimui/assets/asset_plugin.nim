import tables

type
  AssetPlugin* = ref object of RootObj
    props*: TableRef[string, string]

proc newAssetPlugin*(): AssetPlugin =
  AssetPlugin(props: newTable[string, string]())

method invoke*(self: AssetPlugin, asset: RootRef): RootRef {.base.} =
  return asset

method setProperty*(self: AssetPlugin, name: string, value: string) {.base.} =
  if self.props == nil:
    self.props = newTable[string, string]()
  self.props[name] = value

method getProperty*(self: AssetPlugin, name: string, defaultValue: string = ""): string {.base.} =
  if self.props == nil:
    return defaultValue
  if self.props.hasKey(name):
    let v = self.props[name]
    if v != "":
      return v
  return defaultValue
