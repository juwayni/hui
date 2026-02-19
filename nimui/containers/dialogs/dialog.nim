import nimui/core/component
import nimui/core/types
import nimui/containers/box

type
  Dialog* = ref object of Box

proc newDialog*(): Dialog =
  new result
  initComponent(result)
