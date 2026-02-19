import nimui/core/component
import nimui/core/types
import nimui/containers/vbox

type
  SideBar* = ref object of VBox

proc newSideBar*(): SideBar =
  new result
  initComponent(result)
