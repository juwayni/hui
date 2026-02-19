import nimui/core/component
import nimui/core/types

type
  VerticalRule* = ref object of Component

proc newVerticalRule*(): VerticalRule =
  new result
  result.initComponent()
  result.addClass("vertical-rule")
