import nimui/core/component
import nimui/events/animation_event
import nimui/styles/dimension
import nimui/styles/value
import nimui/styles/elements/animation_key_frame
import nimui/styles/elements/animation_key_frames
import nimui/styles/elements/directive
import nimui/util/color
import algorithm

type
  AnimationBuilder* = ref object
    keyFrames*: seq[AnimationKeyFrame]
    target*: Component
    onComplete*: proc() {.closure.}
    duration*: float
    easing*: string

proc newAnimationBuilder*(target: Component = nil, duration: float = 0.2, easing: string = "linear"): AnimationBuilder =
  AnimationBuilder(target: target, duration: duration, easing: easing, keyFrames: @[])

proc findKeyFrameAtTime*(self: AnimationBuilder, time: float): AnimationKeyFrame =
  for kf in self.keyFrames:
    if kf.time.kind == vkDimension and kf.time.dimensionValue.kind == dkPercent:
      if kf.time.dimensionValue.floatValue == time:
        return kf
  return nil

proc setPosition*(self: AnimationBuilder, time: float, propertyName: string, value: float, absolute: bool = false): AnimationBuilder {.discardable.} =
  var kf = self.findKeyFrameAtTime(time)
  if kf == nil:
    kf = newAnimationKeyFrame()
    kf.time = VDimension(Percent(time))
    self.keyFrames.add(kf)

  if absolute:
    kf.directives.add(newDirective(propertyName, VDimension(Px(value))))
  else:
    let currentValue = if self.target != nil: self.target.getProperty(propertyName) else: 0.0
    kf.directives.add(newDirective(propertyName, VDimension(Px(currentValue + value))))

  return self

proc setColor*(self: AnimationBuilder, time: float, propertyName: string, value: Color): AnimationBuilder {.discardable.} =
  var kf = self.findKeyFrameAtTime(time)
  if kf == nil:
    kf = newAnimationKeyFrame()
    kf.time = VDimension(Percent(time))
    self.keyFrames.add(kf)

  kf.directives.add(newDirective(propertyName, VColor(value)))
  return self

type
  ShakeAnimation* = ref object
    target: Component
    direction: string

proc newShakeAnimation*(target: Component, direction: string = "horizontal"): ShakeAnimation =
  ShakeAnimation(target: target, direction: direction)

proc build*(self: ShakeAnimation, builder: AnimationBuilder) =
  if self.direction == "horizontal":
    builder.setPosition(0, "left", 0, false)
    builder.setPosition(10, "left", -10, false)
    builder.setPosition(20, "left", 10, false)
    builder.setPosition(30, "left", -10, false)
    builder.setPosition(40, "left", 10, false)
    builder.setPosition(50, "left", -10, false)
    builder.setPosition(60, "left", 10, false)
    builder.setPosition(70, "left", -10, false)
    builder.setPosition(80, "left", 10, false)
    builder.setPosition(90, "left", -10, false)
    builder.setPosition(100, "left", 0, false)
  elif self.direction == "vertical":
    builder.setPosition(0, "top", 0, false)
    builder.setPosition(10, "top", -10, false)
    builder.setPosition(20, "top", 10, false)
    builder.setPosition(30, "top", -10, false)
    builder.setPosition(40, "top", 10, false)
    builder.setPosition(50, "top", -10, false)
    builder.setPosition(60, "top", 10, false)
    builder.setPosition(70, "top", -10, false)
    builder.setPosition(80, "top", 10, false)
    builder.setPosition(90, "top", -10, false)
    builder.setPosition(100, "top", 0, false)

proc shake*(self: AnimationBuilder, direction: string = "horizontal"): AnimationBuilder {.discardable.} =
  newShakeAnimation(self.target, direction).build(self)
  return self

type
  FlashAnimation* = ref object
    target: Component
    color: Color

proc newFlashAnimation*(target: Component, color: Color = 0xffdddd.int32): FlashAnimation =
  FlashAnimation(target: target, color: color)

proc build*(self: FlashAnimation, builder: AnimationBuilder) =
  builder.setColor(0, "backgroundColor", 0xffffff.int32)
  builder.setColor(50, "backgroundColor", self.color)
  builder.setColor(100, "backgroundColor", 0xffffff.int32)

proc flash*(self: AnimationBuilder, color: Color = 0xffdddd.int32): AnimationBuilder {.discardable.} =
  newFlashAnimation(self.target, color).build(self)
  return self

proc sortFrames*(self: AnimationBuilder) =
  self.keyFrames.sort(proc(f1, f2: AnimationKeyFrame): int =
    var t1 = 0.0
    if f1.time.kind == vkDimension and f1.time.dimensionValue.kind == dkPercent:
      t1 = f1.time.dimensionValue.floatValue
    var t2 = 0.0
    if f2.time.kind == vkDimension and f2.time.dimensionValue.kind == dkPercent:
      t2 = f2.time.dimensionValue.floatValue
    return cmp(t1, t2)
  )

proc play*(self: AnimationBuilder) =
  if self.keyFrames.len == 0:
    if self.onComplete != nil:
      self.onComplete()
    return

  let frames = newAnimationKeyFrames("builder", self.keyFrames)
  let target = self.target
  let onComplete = self.onComplete

  target.registerEvent(AnimationEventEnd, proc(e: any) =
    target.pauseAnimationStyleChanges = false
    # target.componentAnimation = nil # Not in Component yet
    target.unregisterEvents(AnimationEventEnd)
    if onComplete != nil:
      onComplete()
  )

  self.sortFrames()
  target.pauseAnimationStyleChanges = true
  target.applyAnimationKeyFrame(frames, nil) # options pointer nil for now
