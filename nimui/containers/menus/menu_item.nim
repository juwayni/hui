import nimui/core/component
import nimui/core/types
import nimui/containers/hbox

type
  MenuItem* = ref object of HBox

proc newMenuItem*(): MenuItem =
  new result
  initComponent(result)
