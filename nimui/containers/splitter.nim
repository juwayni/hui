import nimui/core/component
import nimui/core/types
import nimui/containers/box

type
  Splitter* = ref object of Box

proc newSplitter*(): Splitter =
  new result
  initComponent(result)
