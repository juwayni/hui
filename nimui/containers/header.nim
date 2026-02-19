import nimui/core/component
import nimui/core/types
import nimui/containers/hbox
import nimui/components/column
import nimui/core/composite_builder
import nimui/layouts/horizontal_layout
import nimui/events/ui_event
import nimui/util/variant
import std/options

type
  Header* = ref object of HBox

proc newHeader*(): Header =
  new result
  initComponent(result)

# Builder
type
  HeaderBuilder* = ref object of CompositeBuilder

method addComponent*(self: HeaderBuilder, child: Component): Component =
  # Add event listeners for sorting
  return procCall self.CompositeBuilder.addComponent(child)

method createBuilder*(self: Header): CompositeBuilder =
  return HeaderBuilder(component: self)

# Layout
type
  HeaderLayout* = ref object of HorizontalLayout

method resizeChildren*(self: HeaderLayout) =
  procCall self.HorizontalLayout.resizeChildren()
  # Logic to align column heights
  discard

method createLayout*(self: Header): Layout =
  return HeaderLayout(component: self)
