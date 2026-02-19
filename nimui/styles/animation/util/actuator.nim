import nimui/core/types
import nimui/styles/easing_function
import nimui/styles/animation/util/property_details
import nimui/styles/animation/util/color_property_details
import nimui/styles/animation/util/string_property_details
import nimui/util/variant
import nimui/util/color
import nimui/util/math_util
import nimui/util/timer
import std/options
import std/strutils

type
  ActuatorOptions* = object
    delay*: Option[float]
    easingFunction*: EasingFunction
    onComplete*: proc() {.gcsafe.}
    onUpdate*: proc(time, delta, position: float) {.gcsafe.}

  Actuator*[T] = ref object
    target*: T
    properties*: Variant # Map-like variant
    duration*: float
    delay*: float
    currentTime: float
    easeFunc: proc(k: float): float {.gcsafe.}
    onComplete: proc() {.gcsafe.}
    onUpdate: proc(time, delta, position: float) {.gcsafe.}
    stopped: bool
    propertyDetails: seq[PropertyDetails[T]]
    colorPropertyDetails: seq[ColorPropertyDetails[T]]
    stringPropertyDetails: seq[StringPropertyDetails[T]]

proc newActuator*[T](target: T, properties: Variant, duration: float, options: ActuatorOptions): Actuator[T] =
  new result
  result.target = target
  result.properties = properties
  result.duration = duration
  result.propertyDetails = @[]
  result.colorPropertyDetails = @[]
  result.stringPropertyDetails = @[]

  result.easeFunc = getEaseFunc(options.easingFunction)
  if options.delay.isSome: result.delay = options.delay.get()
  if options.onComplete != nil: result.onComplete = options.onComplete
  if options.onUpdate != nil: result.onUpdate = options.onUpdate

proc stop*[T](self: Actuator[T]) =
  self.stopped = true

proc initialize[T](self: Actuator[T]) =
  # Logic to extract properties and populate details
  discard

proc finish[T](self: Actuator[T]) =
  self.stopped = true
  if self.onComplete != nil:
    self.onComplete()

proc apply[T](self: Actuator[T], position: float) =
  if self.stopped: return
  let pos = self.easeFunc(position)
  # Apply values to target
  discard

proc nextFrame[T](self: Actuator[T], stamp: float) =
  if self.stopped: return
  let delta = stamp - self.currentTime
  var tweenPosition = delta / self.duration
  if tweenPosition > 1.0: tweenPosition = 1.0

  self.apply(tweenPosition)
  if self.onUpdate != nil:
    self.onUpdate(stamp, delta, tweenPosition)

  if delta >= self.duration:
    self.finish()

proc run*[T](self: Actuator[T]) =
  self.initialize()
  self.stopped = false
  if self.duration == 0:
    self.apply(1.0)
    self.finish()
  else:
    self.currentTime = timer.stamp()
    # Logic to register frame callback
    discard
