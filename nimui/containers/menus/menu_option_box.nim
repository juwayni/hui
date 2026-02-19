import nimui/core/component
import nimui/core/types
import nimui/containers/menus/menu_item

type
  MenuOptionBox* = ref object of MenuItem

proc newMenuOptionBox*(): MenuOptionBox =
  new result
  initComponent(result)
