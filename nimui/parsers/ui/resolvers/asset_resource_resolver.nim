import ./resource_resolver, tables, os
import nimui/toolkit_assets

type
  AssetResourceResolver* = ref object of ResourceResolver
    rootFile: string
    rootDir: string

proc newAssetResourceResolver*(rootFile: string, params: Table[string, string] = initTable[string, string]()): AssetResourceResolver =
  let res = AssetResourceResolver(rootFile: rootFile)
  initResourceResolver(res, params)

  let parts = rootFile.split('/')
  if parts.len > 1:
    res.rootDir = parts[0 .. ^2].join("/") & "/"
  else:
    res.rootDir = ""
  return res

method getResourceData*(self: AssetResourceResolver, r: string): string =
  let f = normalizedPath(self.rootDir & r)
  return ToolkitAssets.instance().getText(f)
