import nimui/events/ui_event

type
  ScrollEvent* = ref object of UIEvent

proc newScrollEvent*(typ: string): ScrollEvent =
  new result
  result.init(typ)
