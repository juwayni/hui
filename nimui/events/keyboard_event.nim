import nimui/events/ui_event

type
  KeyboardEvent* = ref object of UIEvent
    keyCode*: int
    altKey*: bool
    ctrlKey*: bool
    shiftKey*: bool

proc newKeyboardEvent*(typ: string): KeyboardEvent =
  new result
  result.init(typ)
