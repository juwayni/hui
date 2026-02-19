import std/macros
import std/os
import std/strutils
import std/json

macro buildFileList*(path: static string): untyped =
  var files: seq[JsonNode] = @[]

  for file in walkDirRec(path):
    let relativePath = file.relativePath(path)
    let ext = splitFile(relativePath).ext

    var resType = ""
    case ext.toLowerAscii():
      of ".png", ".jpg", ".jpeg": resType = "image"
      of ".ttf": resType = "font"
      else: discard

    if resType != "":
      var name = relativePath.replace("/", "_").replace("\\", "_").replace(".", "_").replace("-", "_")
      files.add(%*{
        "name": name,
        "type": resType,
        "files": [relativePath]
      })

  let config = %*{"files": files}
  # writeFile("resources.json", $config)

  result = newEmptyNode()
