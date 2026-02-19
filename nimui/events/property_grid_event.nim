import nimui/events/ui_event

type
  PropertyGridEvent* = ref object of UIEvent

proc newPropertyGridEvent*(typ: string): PropertyGridEvent =
  new result
  result.init(typ)
