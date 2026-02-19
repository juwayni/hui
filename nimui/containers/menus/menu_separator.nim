import nimui/core/component
import nimui/core/types

type
  MenuSeparator* = ref object of Component

proc newMenuSeparator*(): MenuSeparator =
  new result
  initComponent(result)
