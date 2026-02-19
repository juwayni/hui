import nimui/core/types
import nimui/assets/image_info
import nimui/geom/rectangle

type
  ImageBase* = ref object of ImageSurface
    parentComponent*: Component
    aspectRatio*: float
    left*: float
    top*: float
    imageWidth*: float
    imageHeight*: float
    imageInfo*: ImageInfo
    imageClipRect*: Rectangle

proc initImageBase*(self: ImageBase) =
  self.aspectRatio = 1.0
  self.left = 0
  self.top = 0
  self.imageWidth = 0
  self.imageHeight = 0

method dispose*(self: ImageBase) {.base.} =
  self.parentComponent = nil

method validateData*(self: ImageBase) {.base.} = discard
method validatePosition*(self: ImageBase) {.base.} = discard
method validateDisplay*(self: ImageBase) {.base.} = discard
