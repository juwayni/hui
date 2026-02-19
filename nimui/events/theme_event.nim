import nimui/events/ui_event

type
  ThemeEvent* = ref object of UIEvent

proc newThemeEvent*(typ: string): ThemeEvent =
  new result
  result.init(typ)
