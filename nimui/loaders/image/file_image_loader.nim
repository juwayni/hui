import nimui/loaders/image/image_loader_base
import nimui/assets/image_info
import nimui/util/variant
import nimui/toolkit
import std/strutils

type
  FileImageLoader* = ref object of ImageLoaderBase

proc newFileImageLoader*(): FileImageLoader =
  new result

method load*(self: FileImageLoader, resource: Variant, callback: proc(info: ImageInfo) {.gcsafe.}) =
  let stringResource = resource.toString()
  # Typically file://path
  let path = if stringResource.startsWith("file://"): stringResource.substr(7) else: stringResource
  assets().imageFromFile(path, proc(imageInfo: ImageInfo) {.gcsafe.} =
    # ToolkitAssets.instance.cacheImage(stringResource, imageInfo)
    callback(imageInfo)
  )
