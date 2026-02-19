import nimui/core/types
import nimui/constants/scroll_mode

type
  IScroller* = concept x
    x.ensureVisible(component: Component)
    x.findHorizontalScrollbar(): Component
    x.findVerticalScrollbar(): Component
    x.isScrollableHorizontally() is bool
    x.isScrollableVertically() is bool
    x.isScrollable() is bool
    x.vscrollPos is float
    x.hscrollPos is float
    x.virtual is bool
    x.scrollMode is ScrollMode
