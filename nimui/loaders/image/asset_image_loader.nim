import nimui/loaders/image/image_loader_base
import nimui/assets/image_info
import nimui/util/variant
import nimui/toolkit

type
  AssetImageLoader* = ref object of ImageLoaderBase

proc newAssetImageLoader*(): AssetImageLoader =
  new result

method load*(self: AssetImageLoader, resource: Variant, callback: proc(info: ImageInfo) {.gcsafe.}) =
  assets().getImage(resource, callback)
