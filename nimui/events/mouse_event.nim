import nimui/events/ui_event
import nimui/core/types

type
  MouseEvent* = ref object of UIEvent
    screenX*: float
    screenY*: float
    buttonDown*: bool
    delta*: float
    touchEvent*: bool
    ctrlKey*: bool
    shiftKey*: bool

proc newMouseEvent*(typ: string): MouseEvent =
  new result
  result.init(typ)

method localX*(self: MouseEvent): float {.base.} =
  if self.target == nil: return 0.0
  # return (self.screenX - self.target.screenLeft)
  return 0.0 # TODO

method localY*(self: MouseEvent): float {.base.} =
  if self.target == nil: return 0.0
  # return (self.screenY - self.target.screenTop)
  return 0.0 # TODO
