import nimui/core/types
import nimui/containers/box

type
  ToolTip* = ref object of Box

proc newToolTip*(): ToolTip =
  new result
  initComponent(result)
