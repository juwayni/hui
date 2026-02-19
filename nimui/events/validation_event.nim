import nimui/events/ui_event

type
  ValidationEvent* = ref object of UIEvent

proc newValidationEvent*(typ: string): ValidationEvent =
  new result
  result.init(typ)
