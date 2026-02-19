import nimui/core/component
import nimui/core/types
import nimui/components/scroll
import nimui/layouts/default_layout
import nimui/geom/point
import nimui/util/variant
import std/options

type
  VerticalScroll* = ref object of Scroll

proc newVerticalScroll*(): VerticalScroll =
  new result
  result.initComponent()

# Layout
type
  VerticalScrollLayout* = ref object of DefaultLayout

method resizeChildren*(self: VerticalScrollLayout) =
  procCall self.DefaultLayout.resizeChildren()
  # Scroll thumb resizing logic ...

method repositionChildren*(self: VerticalScrollLayout) =
  procCall self.DefaultLayout.repositionChildren()
  # Scroll thumb repositioning logic ...

method createLayout*(self: VerticalScroll): Layout =
  return VerticalScrollLayout(component: self)
