import nimui/events/ui_event

type
  AppEvent* = ref object of UIEvent

proc newAppEvent*(typ: string): AppEvent =
  new result
  result.init(typ)
