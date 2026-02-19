import nimui/core/component
import nimui/core/types
import nimui/containers/hbox

type
  MenuBar* = ref object of HBox

proc newMenuBar*(): MenuBar =
  new result
  initComponent(result)
