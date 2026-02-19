import nimui/events/ui_event

const
  LocaleEventChanged* = "localeChanged"

type
  LocaleEvent* = ref object of UIEvent

proc newLocaleEvent*(typ: string): LocaleEvent =
  new result
  result.init(typ)
