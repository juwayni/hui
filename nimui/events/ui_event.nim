type
  UIEvent* = ref object of RootObj
    target*: RootRef # For now
    `type`*: string
    bubble*: bool
    canceled*: bool

proc newUIEvent*(eventType: string): UIEvent =
  UIEvent(`type`: eventType)
