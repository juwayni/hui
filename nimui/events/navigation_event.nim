import nimui/events/ui_event

type
  NavigationEvent* = ref object of UIEvent

proc newNavigationEvent*(typ: string): NavigationEvent =
  new result
  result.init(typ)
