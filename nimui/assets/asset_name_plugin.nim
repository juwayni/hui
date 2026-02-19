import nimui/assets/asset_plugin
import nimui/util/variant
import std/strutils

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
  result.props = initTable[string, string]()

method setProperty*(self: AssetNamePlugin, name: string, value: string) =
  switch name:
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

method invoke*(self: AssetNamePlugin, asset: Variant): Variant =
  if asset.kind == vkString:
    var stringAsset = asset.toString()
    var matched = true
    var compare = ""

    if self.startsWith != "":
      matched = stringAsset.startsWith(self.startsWith)
      compare = self.startsWith

    if self.endsWith != "":
      matched = stringAsset.endsWith(self.endsWith)
      compare = self.endsWith

    if matched:
      if self.prefix != "":
        stringAsset = self.prefix & stringAsset

      if self.replaceWith != "":
        if compare != "":
          stringAsset = stringAsset.replace(compare, self.replaceWith)
        if self.findChars != "":
          for c in self.findChars:
            stringAsset = stringAsset.replace($c, self.replaceWith)

      if self.removeExtension:
        let n = stringAsset.lastIndexOf('.')
        if n != -1:
          stringAsset = stringAsset[0 ..< n]

      return toVariant(stringAsset)

  return asset
