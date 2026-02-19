import nimui/core/component
import nimui/core/types
import nimui/containers/hbox

type
  WindowHeader* = ref object of HBox

proc newWindowHeader*(): WindowHeader =
  new result
  initComponent(result)
