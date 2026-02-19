import nimui/core/component
import nimui/core/types

type
  HorizontalRule* = ref object of Component

proc newHorizontalRule*(): HorizontalRule =
  new result
  result.initComponent()
  result.addClass("horizontal-rule")

# HorizontalRule is simple, logic from Rule.hx will apply if needed
