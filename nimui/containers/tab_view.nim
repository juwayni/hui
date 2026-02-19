import nimui/core/component
import nimui/core/types
import nimui/containers/vbox

type
  TabView* = ref object of VBox

proc newTabView*(): TabView =
  new result
  initComponent(result)
