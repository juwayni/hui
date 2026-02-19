import nimui/core/component
import nimui/core/types
import nimui/containers/vbox

type
  Menu* = ref object of VBox

proc newMenu*(): Menu =
  new result
  initComponent(result)
