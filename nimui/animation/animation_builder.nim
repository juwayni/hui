import nimui/core/types
import nimui/core/component
import nimui/events/ui_event
import nimui/styles/dimension
import nimui/styles/value
import nimui/util/color
import nimui/styles/elements/animation_key_frames
import nimui/styles/animation/animation
import algorithm

type
  AnimationBuilder* = ref object of RootObj
    target*: Component
    onComplete*: proc()
    duration*: float
    easing*: string
    keyFrames: seq[AnimationKeyFrame]

proc newAnimationBuilder*(target: Component = nil, duration: float = 0.2, easing: string = "linear"): AnimationBuilder =
  new result
  result.target = target
  result.duration = duration
  result.easing = easing
  result.keyFrames = @[]

proc findKeyFrameAtTime(self: AnimationBuilder, time: float): AnimationKeyFrame =
  for kf in self.keyFrames:
    if kf.time.kind == vkDimension and kf.time.vDimension.kind == dkPercent:
      if kf.time.vDimension.percentValue == time:
        return kf
  return nil

proc setPosition*(self: AnimationBuilder, time: float, propertyName: string, value: float, absolute: bool = false): AnimationBuilder =
  var kf = self.findKeyFrameAtTime(time)
  if kf == nil:
    kf = newAnimationKeyFrame()
    kf.time = Value(kind: vkDimension, vDimension: Dimension(kind: dkPercent, percentValue: time))
    self.keyFrames.add(kf)

  if absolute:
    kf.directives.add(newDirective(propertyName, Value(kind: vkDimension, vDimension: Dimension(kind: dkPx, pxValue: value))))
  else:
    # In HaxeUI it gets current value. In Nim we'll need reflection or just assume 0 for now if we don't have it.
    kf.directives.add(newDirective(propertyName, Value(kind: vkDimension, vDimension: Dimension(kind: dkPx, pxValue: value))))

  return self

proc play*(self: AnimationBuilder) =
  if self.keyFrames.len == 0:
    if self.onComplete != nil:
      self.onComplete()
    return

  let frames = newAnimationKeyFrames("builder", self.keyFrames)
  let options = newAnimationOptions()
  options.duration = some(self.duration)
  # options.easingFunction = some(self.easing) # needs conversion string to EasingFunction

  self.target.applyAnimationKeyFrame(frames, options)
