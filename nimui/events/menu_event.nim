import nimui/events/ui_event
import nimui/containers/menus/menu_item

type
  MenuEvent* = ref object of UIEvent
    menuItem*: MenuItem

proc newMenuEvent*(typ: string): MenuEvent =
  new result
  result.init(typ)
