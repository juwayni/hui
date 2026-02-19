import nimui/core/component
import nimui/core/types
import nimui/containers/box
import nimui/events/ui_event
import nimui/util/variant
import nimui/toolkit_assets
import nimui/toolkit
import std/json
import std/times
import std/math

type
  AtlasFrame* = object
    x*, y*, w*, h*: float

  AtlasPlayer* = ref object of Box
    animationDirection*: string
    autoPlay*: bool
    playing*: bool
    frames*: seq[AtlasFrame]
    resourceInternal*: Variant
    atlasInternal*: string
    targetFrameRateInternal*: int
    frameInterval*: float
    nextFrameMs*: float
    currentFrameIndex*: int
    currentBounceDirection*: string

proc newAtlasPlayer*(): AtlasPlayer =
  new result
  result.initComponent()
  result.animationDirection = "forward"
  result.autoPlay = true
  result.playing = false
  result.frames = @[]
  result.targetFrameRateInternal = 60
  result.currentFrameIndex = -1
  result.currentBounceDirection = "forward"

method resource*(self: AtlasPlayer): Variant {.base.} = self.resourceInternal
method `resource=`*(self: AtlasPlayer, value: Variant) {.base.} =
  self.resourceInternal = value
  # self.checkAtlas()

method atlas*(self: AtlasPlayer): string {.base.} = self.atlasInternal
method `atlas=`*(self: AtlasPlayer, value: string) {.base.} =
  self.atlasInternal = value
  # self.checkAtlas()

method showFrame*(self: AtlasPlayer, frameIndex: int) {.base.} =
  if self.currentFrameIndex == frameIndex:
    return
  self.currentFrameIndex = frameIndex
  if frameIndex < 0 or frameIndex >= self.frames.len:
    return

  let frame = self.frames[frameIndex]
  # self.customStyle.backgroundImageClipLeft = frame.x ...
  self.invalidateComponentStyle()

method nextFrame*(self: AtlasPlayer) {.base.} =
  var nextIndex = self.currentFrameIndex + 1
  if nextIndex >= self.frames.len:
    nextIndex = 0
  self.showFrame(nextIndex)

method prevFrame*(self: AtlasPlayer) {.base.} =
  var nextIndex = self.currentFrameIndex - 1
  if nextIndex < 0:
    nextIndex = self.frames.len - 1
  self.showFrame(nextIndex)

method boundFrame*(self: AtlasPlayer) {.base.} =
  if self.currentBounceDirection == "forward":
    var nextIndex = self.currentFrameIndex + 1
    if nextIndex >= self.frames.len:
      nextIndex = self.frames.len - 1
      self.currentBounceDirection = "reverse"
    self.showFrame(nextIndex)
  else:
    var nextIndex = self.currentFrameIndex - 1
    if nextIndex < 0:
      nextIndex = 0
      self.currentBounceDirection = "forward"
    self.showFrame(nextIndex)

method validateComponentLayout*(self: AtlasPlayer): bool =
  if self.currentFrameIndex != -1:
    let frame = self.frames[self.currentFrameIndex]
    if self.autoWidth:
      self.width = frame.w
    if self.autoHeight:
      self.height = frame.h
  return false
