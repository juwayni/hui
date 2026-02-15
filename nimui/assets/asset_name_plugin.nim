import nimui/assets/asset_plugin
import strutils
import tables

type
  AssetNamePlugin* = ref object of AssetPlugin
    startsWith*: string
    prefix*: string
    replaceWith*: string
    removeExtension*: bool
    findChars*: string
    endsWith*: string

proc newAssetNamePlugin*(): AssetNamePlugin =
  let res = AssetNamePlugin()
  res.props = newTable[string, string]()
  return res

method setProperty*(self: AssetNamePlugin, name: string, value: string) =
  case name:
    of "startsWith": self.startsWith = value
    of "prefix": self.prefix = value
    of "replaceWith": self.replaceWith = value
    of "removeExtension": self.removeExtension = (value == "true")
    of "findChars": self.findChars = value
    of "endsWith": self.endsWith = value
    else: procCall self.AssetPlugin.setProperty(name, value)

# We use a wrapper to represent Dynamic strings in Nim
type StringAsset* = ref object of RootObj
  val*: string

method invoke*(self: AssetNamePlugin, asset: RootRef): RootRef =
  if asset != nil and asset of StringAsset:
    var stringAsset = StringAsset(asset).val
    var match = true
    var compare = ""

    if self.startsWith != "":
      match = stringAsset.startsWith(self.startsWith)
      compare = self.startsWith

    if self.endsWith != "":
      match = stringAsset.endsWith(self.endsWith)
      compare = self.endsWith

    if match:
      if self.prefix != "":
        stringAsset = self.prefix & stringAsset

      if self.replaceWith != "":
        if compare != "":
          stringAsset = stringAsset.replace(compare, self.replaceWith)
        if self.findChars != "":
          for c in self.findChars:
            stringAsset = stringAsset.replace($c, self.replaceWith)

      if self.removeExtension:
        let n = stringAsset.rfind('.')
        if n != -1:
          stringAsset = stringAsset[0 .. n-1]

    return StringAsset(val: stringAsset)

  return asset
