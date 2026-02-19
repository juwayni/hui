import nimui/core/component
import nimui/core/types
import nimui/containers/vbox

type
  Menus* = ref object of VBox

proc newMenus*(): Menus =
  new result
  initComponent(result)
