import nimui/core/component
import nimui/core/types
import nimui/containers/splitter
import nimui/events/mouse_event
import nimui/util/variant

type
  HorizontalSplitter* = ref object of Splitter

proc newHorizontalSplitter*(): HorizontalSplitter =
  new result
  initComponent(result)
  result.layoutNameInternal = "horizontal"

# Builder
type
  HorizontalSplitterBuilder* = ref object of SplitterBuilder

method getSplitterClass*(self: HorizontalSplitterBuilder): string =
  return "horizontal-splitter-gripper"

method createBuilder*(self: HorizontalSplitter): CompositeBuilder =
  return HorizontalSplitterBuilder(component: self)

# Events
type
  HorizontalSplitterEvents* = ref object of SplitterEvents

method createEvents*(self: HorizontalSplitter): Events =
  return HorizontalSplitterEvents(target: self)
