import nimui/assets/image_info
import nimui/util/variant
import nimui/core/types

type
  ImageLoaderBase* = ref object of RootObj

proc newImageLoaderBase*(): ImageLoaderBase =
  new result

method load*(self: ImageLoaderBase, resource: Variant, callback: proc(info: ImageInfo) {.gcsafe.}) {.base.} =
  discard

method postProcess*(self: ImageLoaderBase, resource: Variant, image: Component) {.base.} =
  discard
