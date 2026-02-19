import nimui/core/component
import nimui/core/types
import nimui/components/scroll
import nimui/layouts/default_layout
import nimui/geom/point
import nimui/util/variant
import std/options

type
  HorizontalScroll* = ref object of Scroll

proc newHorizontalScroll*(): HorizontalScroll =
  new result
  result.initComponent()

# Layout
type
  HorizontalScrollLayout* = ref object of DefaultLayout

method resizeChildren*(self: HorizontalScrollLayout) =
  procCall self.DefaultLayout.resizeChildren()
  # Scroll thumb resizing logic ...

method repositionChildren*(self: HorizontalScrollLayout) =
  procCall self.DefaultLayout.repositionChildren()
  # Scroll thumb repositioning logic ...

method createLayout*(self: HorizontalScroll): Layout =
  return HorizontalScrollLayout(component: self)
