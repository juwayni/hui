import nimui/core/types
import nimui/core/component
import nimui/events/ui_event
import nimui/styles/dimension
import nimui/styles/value
import nimui/util/color
import asyncdispatch, times

type
  AnimationBuilder* = ref object of RootObj
    target*: Component
    onComplete*: proc()
    duration*: float
    easing*: string

proc newAnimationBuilder*(target: Component = nil, duration: float = 0.2, easing: string = "linear"): AnimationBuilder =
  new result
  result.target = target
  result.duration = duration
  result.easing = easing

method play*(self: AnimationBuilder) {.base.} =
  let start = cpuTime()
  let s = self
  proc animate() {.async.} =
    while true:
      let elapsed = cpuTime() - start
      if elapsed >= s.duration:
        break
      # Here we would interpolate properties.
      # For now, just wait.
      await sleepAsync(16) # ~60fps

    if s.onComplete != nil:
      s.onComplete()

  asyncCheck animate()
