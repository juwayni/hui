import nimui/core/component
import nimui/core/types
import nimui/containers/box
import nimui/layouts/vertical_layout
import nimui/layouts/layout

type
  VBox* = ref object of Box

proc newVBox*(): VBox =
  new result
  initComponent(result)

method createLayout*(self: VBox): Layout =
  return newVerticalLayout()
