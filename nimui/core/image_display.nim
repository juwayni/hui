import nimui/backend/image_display_impl
import nimui/assets/image_info
import nimui/geom/rectangle
import nimui/validation/invalidation_flags
import nimui/core/types
import std/tables

type
  ImageDisplay* = ref object of ImageDisplayImpl
    invalidationFlags: Table[string, bool]
    isAllInvalid: bool
    isValidating: bool

proc newImageDisplay*(): ImageDisplay =
  new result
  result.invalidationFlags = initTable[string, bool]()

method left*(self: ImageDisplay): float {.base.} = self.left
method `left=`*(self: ImageDisplay, value: float) {.base.} =
  if self.left == value: return
  self.left = value
  self.invalidateComponent(InvalidationFlags.POSITION)

method top*(self: ImageDisplay): float {.base.} = self.top
method `top=`*(self: ImageDisplay, value: float) {.base.} =
  if self.top == value: return
  self.top = value
  self.invalidateComponent(InvalidationFlags.POSITION)

method imageWidth*(self: ImageDisplay): float {.base.} = self.imageWidth
method `imageWidth=`*(self: ImageDisplay, value: float) {.base.} =
  if self.imageWidth == value or value <= 0: return
  self.imageWidth = value
  self.invalidateComponent(InvalidationFlags.DISPLAY)

method imageHeight*(self: ImageDisplay): float {.base.} = self.imageHeight
method `imageHeight=`*(self: ImageDisplay, value: float) {.base.} =
  if self.imageHeight == value or value <= 0: return
  self.imageHeight = value
  self.invalidateComponent(InvalidationFlags.DISPLAY)

method imageInfo*(self: ImageDisplay): ImageInfo {.base.} = self.imageInfo
method `imageInfo=`*(self: ImageDisplay, value: ImageInfo) {.base.} =
  if self.imageInfo == value: return
  self.imageInfo = value
  self.imageWidth = value.width.float
  self.imageHeight = value.height.float
  self.invalidateComponent(InvalidationFlags.DATA)
  self.invalidateComponent(InvalidationFlags.DISPLAY)

method imageClipRect*(self: ImageDisplay): Rectangle {.base.} = self.imageClipRect
method `imageClipRect=`*(self: ImageDisplay, value: Rectangle) {.base.} =
  self.imageClipRect = value
  self.invalidateComponent(InvalidationFlags.DISPLAY)

method isComponentInvalid*(self: ImageDisplay, flag: string = InvalidationFlags.ALL): bool {.base.} =
  if self.isAllInvalid: return true
  if flag == InvalidationFlags.ALL:
    return self.invalidationFlags.len > 0
  return self.invalidationFlags.hasKey(flag)

method invalidateComponent*(self: ImageDisplay, flag: string = InvalidationFlags.ALL) {.base.} =
  if self.parentComponent == nil: return
  if flag == InvalidationFlags.ALL:
    self.isAllInvalid = true
    self.parentComponent.invalidateComponent(InvalidationFlags.IMAGE_DISPLAY)
  elif not self.invalidationFlags.hasKey(flag):
    self.invalidationFlags[flag] = true
    self.parentComponent.invalidateComponent(InvalidationFlags.IMAGE_DISPLAY)

method validateComponent*(self: ImageDisplay) {.base.} =
  if self.isValidating or not self.isComponentInvalid(): return
  self.isValidating = true

  if self.isComponentInvalid(InvalidationFlags.DATA):
    self.validateData()
  if self.isComponentInvalid(InvalidationFlags.POSITION):
    self.validatePosition()
  if self.isComponentInvalid(InvalidationFlags.DISPLAY):
    self.validateDisplay()

  self.invalidationFlags.clear()
  self.isAllInvalid = false
  self.isValidating = false
