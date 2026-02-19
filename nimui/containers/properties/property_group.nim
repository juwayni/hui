import nimui/core/component
import nimui/core/types
import nimui/containers/vbox

type
  PropertyGroup* = ref object of VBox

proc newPropertyGroup*(): PropertyGroup =
  new result
  initComponent(result)
