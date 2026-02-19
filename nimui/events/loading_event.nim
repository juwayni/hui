import nimui/events/ui_event

type
  LoadingEvent* = ref object of UIEvent
    progress*: float
    maxProgress*: float

proc newLoadingEvent*(typ: string): LoadingEvent =
  new result
  result.init(typ)
