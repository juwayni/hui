import nimui/events/ui_event

type
  FocusEvent* = ref object of UIEvent

proc newFocusEvent*(typ: string): FocusEvent =
  new result
  result.init(typ)
