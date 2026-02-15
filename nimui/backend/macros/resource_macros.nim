import macros, os, strutils, json

macro buildFileList*(path: static[string]): untyped =
  var files: seq[JsonNode] = @[]

  for file in walkDirRec(path):
    let relativePath = file.replace(path, "").replace("\\", "/")
    let normalizedPath = if relativePath.startsWith("/"): relativePath[1..^1] else: relativePath

    let parts = normalizedPath.split('.')
    if parts.len < 2: continue

    let resourceName = parts[0..^2].join("_")
      .replace("/", "_")
      .replace(" ", "_")
      .replace("-", "_")

    var fileType = ""
    if normalizedPath.endsWith(".png") or normalizedPath.endsWith(".jpg"):
      fileType = "image"
    elif normalizedPath.endsWith(".ttf"):
      fileType = "font"

    if fileType != "":
      files.add(%*{
        "name": resourceName,
        "type": fileType,
        "files": [normalizedPath]
      })

  let config = %*{"files": files}
  let jsonString = config.pretty()

  # In a real scenario we'd write to a configured path
  # For now just echo or return as string
  # writeFile("files.json", jsonString)

  return quote do:
    `jsonString`
