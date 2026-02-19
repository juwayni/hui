import nimui/events/ui_event

type
  DialogEvent* = ref object of UIEvent
    button*: string

proc newDialogEvent*(typ: string): DialogEvent =
  new result
  result.init(typ)
