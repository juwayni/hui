import nimui/core/types
import nimui/util/variant

type
  FileSelector* = ref object

proc newFileSelector*(): FileSelector =
  new result

proc selectFile*(self: FileSelector, callback: proc(cancelled: bool, files: seq[string]) {.gcsafe.}) =
  # Native implementation for Pixie/Windy would use a system dialog
  callback(true, @[])
