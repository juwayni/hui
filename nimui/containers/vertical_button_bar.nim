import nimui/core/component
import nimui/core/types
import nimui/containers/button_bar

type
  VerticalButtonBar* = ref object of ButtonBar

proc newVerticalButtonBar*(): VerticalButtonBar =
  new result
  initComponent(result)
