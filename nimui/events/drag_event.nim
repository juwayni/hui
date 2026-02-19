import nimui/events/ui_event

type
  DragEvent* = ref object of UIEvent
    left*: float
    top*: float

proc newDragEvent*(typ: string): DragEvent =
  new result
  result.init(typ)
  result.left = 0
  result.top = 0
