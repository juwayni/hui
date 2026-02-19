import nimui/constants/animation_direction
import nimui/constants/animation_fill_mode
import nimui/styles/easing_function
import nimui/styles/elements/animation_key_frames
import nimui/util/style_util
import std/options
import nimui/util/variant
import nimui/styles/dimension
import nimui/styles/value
import nimui/styles/elements/directive
import nimui/styles/animation/util/actuator
import nimui/core/types
import tables

type
  AnimationOptions* = ref object of RootObj
    duration*: Option[float]
    delay*: Option[float]
    iterationCount*: Option[int]
    easingFunction*: Option[EasingFunction]
    direction*: Option[AnimationDirection]
    fillMode*: Option[AnimationFillMode]

proc newAnimationOptions*(): AnimationOptions =
  AnimationOptions(
    duration: none(float),
    delay: none(float),
    iterationCount: none(int),
    easingFunction: none(EasingFunction),
    direction: none(AnimationDirection),
    fillMode: none(AnimationFillMode)
  )

const DEFAULT_DURATION = 0.0
const DEFAULT_DELAY = 0.0
const DEFAULT_ITERATION_COUNT = 1
const DEFAULT_EASING_FUNCTION = EasingFunctionEase
const DEFAULT_DIRECTION = AnimationDirectionNormal
const DEFAULT_FILL_MODE = AnimationFillModeForwards

type
  KeyFrame* = ref object
    directives*: seq[Directive]
    time*: float
    delay*: float
    easingFunction*: EasingFunction
    actuator: Actuator[Component]

proc newKeyFrame*(): KeyFrame =
  KeyFrame(directives: @[], time: 0, delay: 0, easingFunction: DEFAULT_EASING_FUNCTION, actuator: nil)

proc stop*(self: KeyFrame) =
  if self.actuator != nil:
    self.actuator.stopped = true
    self.actuator = nil

proc run*(self: KeyFrame, target: Component, cb: proc() {.gcsafe.}) {.gcsafe.} =
  if self.actuator != nil: return

  var properties = initTable[string, Variant]()
  for d in self.directives:
    properties[d.directive] = d.value.toVariant()

  let options = newActuatorOptions()
  options.delay = some(self.delay)
  options.easingFunction = some(self.easingFunction)
  options.onComplete = cb

  {.cast(gcsafe).}:
    self.actuator = actuator.tween[Component](target, properties, self.time, options)

type
  Animation* = ref object of RootObj
    target*: Component
    options*: AnimationOptions
    duration*: float
    delay*: float
    iterationCount*: int
    easingFunction*: EasingFunction
    direction*: AnimationDirection
    fillMode*: AnimationFillMode
    name*: string
    running*: bool
    initialized: bool
    keyframes: seq[KeyFrame]
    currentKeyFrameIndex: int
    currentIterationCount: int

proc newAnimation*(target: Component, options: AnimationOptions = nil): Animation =
  let anim = Animation(
    target: target,
    options: options,
    duration: DEFAULT_DURATION,
    delay: DEFAULT_DELAY,
    iterationCount: DEFAULT_ITERATION_COUNT,
    easingFunction: DEFAULT_EASING_FUNCTION,
    direction: DEFAULT_DIRECTION,
    fillMode: DEFAULT_FILL_MODE,
    running: false,
    initialized: false,
    keyframes: @[],
    currentKeyFrameIndex: -1,
    currentIterationCount: -1
  )
  if options != nil:
    if options.duration.isSome: anim.duration = options.duration.get
    if options.delay.isSome: anim.delay = options.delay.get
    if options.iterationCount.isSome: anim.iterationCount = options.iterationCount.get
    if options.easingFunction.isSome: anim.easingFunction = options.easingFunction.get
    if options.direction.isSome: anim.direction = options.direction.get
    if options.fillMode.isSome: anim.fillMode = options.fillMode.get
  return anim

proc createWithKeyFrames*(animationKeyFrames: AnimationKeyFrames, target: Component, options: AnimationOptions = nil): Animation =
  let animation = newAnimation(target, options)
  animation.name = animationKeyFrames.id

  for keyFrame in animationKeyFrames.keyFrames:
    let kf = newKeyFrame()
    if keyFrame.time.kind == vkDimension:
      let v = keyFrame.time.vDimension
      if v.kind == dkPercent:
        kf.time = v.percentValue / 100.0
        kf.easingFunction = animation.easingFunction
        kf.directives = keyFrame.directives
        animation.keyframes.add(kf)

  return animation

proc runNextKeyframe(self: Animation, onFinish: proc() {.gcsafe.}) {.gcsafe.}

proc run*(self: Animation, onFinish: proc() {.gcsafe.} = nil) =
  if self.keyframes.len == 0 or self.running: return

  # if not self.initialized: self.initialize() # simplified
  self.currentKeyFrameIndex = -1
  self.currentIterationCount = 0
  self.running = true
  # self.saveState()
  self.runNextKeyframe(onFinish)

proc runNextKeyframe(self: Animation, onFinish: proc() {.gcsafe.}) {.gcsafe.} =
  if not self.running: return

  self.currentKeyFrameIndex += 1
  if self.currentKeyFrameIndex >= self.keyframes.len:
    self.currentKeyFrameIndex = -1
    # self.restoreState()
    self.currentIterationCount += 1
    if self.iterationCount == -1 or self.currentIterationCount < self.iterationCount:
      # self.saveState()
      self.runNextKeyframe(onFinish)
    else:
      self.running = false
      if onFinish != nil: onFinish()
  else:
    self.keyframes[self.currentKeyFrameIndex].run(self.target, proc() {.gcsafe.} =
      self.runNextKeyframe(onFinish)
    )

proc stop*(self: Animation) =
  if not self.running: return
  self.running = false
  if self.currentKeyFrameIndex >= 0:
    self.keyframes[self.currentKeyFrameIndex].stop()
    self.currentKeyFrameIndex = -1
  # self.restoreState()
