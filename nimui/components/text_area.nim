import nimui/core/component
import nimui/core/types
import nimui/core/interactive_component
import nimui/core/composite_builder
import nimui/layouts/default_layout
import nimui/behaviours/data_behaviour
import nimui/behaviours/default_behaviour
import nimui/util/variant
import nimui/geom/size
import std/options

type
  TextArea* = ref object of InteractiveComponent
    autoScrollToBottomInternal*: bool

proc newTextArea*(): TextArea =
  new result
  result.initComponent()

# Layout
type
  TextAreaLayout* = ref object of DefaultLayout

method resizeChildren*(self: TextAreaLayout) =
  procCall self.DefaultLayout.resizeChildren()
  # Text input and scrollbar resizing
  discard

method repositionChildren*(self: TextAreaLayout) =
  procCall self.DefaultLayout.repositionChildren()
  # Text input and scrollbar positioning
  discard

method createLayout*(self: TextArea): Layout =
  return TextAreaLayout(component: self)

# Behaviours
type
  TextAreaTextBehaviour* = ref object of DataBehaviour
  TextAreaWrapBehaviour* = ref object of DataBehaviour

# Builder
type
  TextAreaBuilder* = ref object of CompositeBuilder

method checkScrolls*(self: TextAreaBuilder) {.base.} =
  discard

method createBuilder*(self: TextArea): CompositeBuilder =
  return TextAreaBuilder(component: self)
