import nimui/core/component
import nimui/core/types
import nimui/containers/menus/menu_item

type
  MenuCheckBox* = ref object of MenuItem

proc newMenuCheckBox*(): MenuCheckBox =
  new result
  initComponent(result)
