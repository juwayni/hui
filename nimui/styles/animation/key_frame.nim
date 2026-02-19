import nimui/core/types
import nimui/events/ui_event
import nimui/events/animation_event
import nimui/styles/animation/util/actuator
import nimui/styles/easing_function
import nimui/styles/elements/directive
import nimui/util/variant
import std/options

type
  KeyFrame* = ref object
    directives*: seq[Directive]
    time*: float
    delay*: float
    easingFunction*: EasingFunction
    actuator: Actuator[Component]

proc newKeyFrame*(): KeyFrame =
  new result
  result.directives = @[]

proc stop*(self: KeyFrame) =
  if self.actuator != nil:
    self.actuator.stop()
    self.actuator = nil

proc run*(self: KeyFrame, target: Component, cb: proc() {.gcsafe.}) =
  if self.actuator != nil: return

  var properties = toVariant(initTable[string, Variant]())
  # Populate properties from directives

  self.actuator = newActuator(target, properties, self.time, ActuatorOptions(
    delay: some(self.delay),
    easingFunction: self.easingFunction,
    onComplete: proc() {.gcsafe.} =
      self.actuator = nil
      cb()
    ,
    onUpdate: proc(time, delta, position: float) {.gcsafe.} =
      let event = newAnimationEvent("animationframe")
      event.currentTime = time
      event.delta = delta
      event.position = position
      target.dispatch(event)
  ))
  self.actuator.run()
