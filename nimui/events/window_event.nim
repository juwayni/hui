import nimui/events/ui_event

type
  WindowEvent* = ref object of UIEvent

proc newWindowEvent*(typ: string): WindowEvent =
  new result
  result.init(typ)
