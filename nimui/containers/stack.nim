import nimui/core/component
import nimui/core/types
import nimui/containers/box
import nimui/layouts/layout

type
  Stack* = ref object of Box

proc newStack*(): Stack =
  new result
  initComponent(result)

type
  StackLayout* = ref object of Layout

method createLayout*(self: Stack): Layout =
  return StackLayout()
