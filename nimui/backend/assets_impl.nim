import nimui/assets/font_info
import nimui/assets/image_info
import nimui/backend/toolkit_options
import nimui/backend/image_data
import nimui/backend/font_data
import pixie
import std/asyncdispatch

type
  AssetsBase* = ref object of RootObj

  AssetsImpl* = ref object of AssetsBase

method getImageInternal*(self: AssetsImpl, resourceId: string, callback: proc(info: ImageInfo) {.gcsafe.}) {.base, gcsafe.} =
  try:
    let img = readImage(resourceId)
    let info = ImageInfo(width: img.width.float, height: img.height.float, data: cast[ImageData](img))
    callback(info)
  except:
    callback(nil)

method getFontInternal*(self: AssetsImpl, resourceId: string, callback: proc(info: FontInfo) {.gcsafe.}) {.base, gcsafe.} =
  callback(nil)

method imageFromBytes*(self: AssetsImpl, bytes: seq[byte], callback: proc(info: ImageInfo) {.gcsafe.}) {.base, gcsafe.} =
  try:
    var data = ""
    if bytes.len > 0:
      data = cast[string](bytes)
    let img = decodeImage(data)
    let info = ImageInfo(width: img.width.float, height: img.height.float, data: cast[ImageData](img))
    callback(info)
  except:
    callback(nil)
