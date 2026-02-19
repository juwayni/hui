import nimui/core/component
import nimui/core/types
import nimui/containers/splitter

type
  VerticalSplitter* = ref object of Splitter

proc newVerticalSplitter*(): VerticalSplitter =
  new result
  initComponent(result)
