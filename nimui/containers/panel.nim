import nimui/core/component
import nimui/core/types
import nimui/containers/vbox

type
  Panel* = ref object of VBox

proc newPanel*(): Panel =
  new result
  initComponent(result)
