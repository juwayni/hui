import nimui/core/component
import nimui/core/types
import nimui/containers/button_bar
import nimui/layouts/horizontal_layout
import nimui/core/composite_builder
import nimui/util/variant

type
  HorizontalButtonBar* = ref object of ButtonBar

proc newHorizontalButtonBar*(): HorizontalButtonBar =
  new result
  initComponent(result)

# Layout
type
  HorizontalButtonBarLayout* = ref object of HorizontalLayout

method resizeChildren*(self: HorizontalButtonBarLayout) =
  procCall self.HorizontalLayout.resizeChildren()
  # Max height logic
  discard

method createLayout*(self: HorizontalButtonBar): Layout =
  return HorizontalButtonBarLayout(component: self)

# Builder
type
  HorizontalButtonBarBuilder* = ref object of ButtonBarBuilder

method createBuilder*(self: HorizontalButtonBar): CompositeBuilder =
  return HorizontalButtonBarBuilder(component: self)
