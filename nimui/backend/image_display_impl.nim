import nimui/backend/image_base
import nimui/assets/image_info
import pixie

type
  ImageDisplayImpl* = ref object of ImageBase
    buffer*: Image

method validateData*(self: ImageDisplayImpl) =
  if self.imageInfo != nil:
    self.buffer = self.imageInfo.data
    var w = self.imageInfo.width.float
    var h = self.imageInfo.height.float

    if self.imageWidth <= 0:
      self.imageWidth = w
    if self.imageHeight <= 0:
      self.imageHeight = h

    self.aspectRatio = w / h
  else:
    self.dispose()
    self.imageWidth = 0
    self.imageHeight = 0

method scaled*(self: ImageDisplayImpl): bool {.base.} =
  if self.imageInfo == nil:
    return false
  return self.imageWidth != self.imageInfo.width.float or self.imageHeight != self.imageInfo.height.float
