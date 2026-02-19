import ./resource_resolver, ../../../util/string_util, tables, os, strutils, ../../../util/variant

type
  FileResourceResolver* = ref object of ResourceResolver
    rootFile: string
    rootDir: string

proc newFileResourceResolver*(rootFile: string, params: Table[string, Variant] = initTable[string, Variant]()): FileResourceResolver =
  let res = FileResourceResolver(rootFile: rootFile)
  initResourceResolver(res, params)

  let parts = rootFile.split('/')
  if parts.len > 1:
    res.rootDir = parts[0 .. ^2].join("/") & "/"
  else:
    res.rootDir = ""
  return res

method getResourceData*(self: FileResourceResolver, r: string): string =
  let f = self.rootDir & "/" & r
  var data = ""
  if f.fileExists():
    data = readFile(f)
  elif r.fileExists():
    data = readFile(r)

  if data != "":
    return replaceVars(data, self.params)

  echo "WARNING: Could not find file: ", f
  return ""
