import nimui/assets/asset_plugin
import strutils

type
  AssetNamePlugin* = ref object of AssetPlugin
    startsWith*: string
    prefix*: string
    replaceWith*: string
    removeExtension*: bool
    findChars*: string
    endsWith*: string

proc newAssetNamePlugin*(): AssetNamePlugin =
  new result

method setProperty*(self: AssetNamePlugin, name: string, value: string) =
  case name:
    of "startsWith":
      self.startsWith = value
    of "prefix":
      self.prefix = value
    of "replaceWith":
      self.replaceWith = value
    of "removeExtension":
      self.removeExtension = (value == "true")
    of "findChars":
      self.findChars = value
    of "endsWith":
      self.endsWith = value
    else:
      procCall self.AssetPlugin.setProperty(name, value)

method invoke*(self: AssetNamePlugin, asset: auto): auto =
  if asset is string:
    var stringAsset = asset.string
    var matches = true
    var compare = ""

    if self.startsWith != "":
      matches = stringAsset.startsWith(self.startsWith)
      compare = self.startsWith

    if self.endsWith != "":
      matches = stringAsset.endsWith(self.endsWith)
      compare = self.endsWith

    if matches:
      if self.prefix != "":
        stringAsset = self.prefix & stringAsset

      if self.replaceWith != "":
        stringAsset = stringAsset.replace(compare, self.replaceWith)
        if self.findChars != "":
          for c in self.findChars:
            stringAsset = stringAsset.replace($c, self.replaceWith)

      if self.removeExtension:
        let n = stringAsset.rfind(".")
        if n != -1:
          stringAsset = stringAsset[0 ..< n]

      return stringAsset

  return asset
