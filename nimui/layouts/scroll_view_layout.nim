import nimui/layouts/default_layout
import nimui/core/types
import nimui/geom/size
import std/options

type
  ScrollViewLayout* = ref object of DefaultLayout

proc newScrollViewLayout*(): ScrollViewLayout =
  new result

method repositionChildren*(self: ScrollViewLayout) =
  # Porting scrollview layout logic
  if self.component == nil: return

  # Find contents and scrolls
  # In HaxeUI it uses findComponent by CSS class or Type
  # For now, we'll assume they are child components we can identify

  for child in self.component.childComponents:
    # repositionChild(child) logic for scrolls
    discard

  # contents.moveComponent(...)
  discard

method resizeChildren*(self: ScrollViewLayout) =
  procCall self.DefaultLayout.resizeChildren()
  # Specific resize for scrollbars
  discard

method usableSize*(self: ScrollViewLayout): Size =
  var size = procCall self.DefaultLayout.usableSize()
  # Subtract scrollbar sizes if visible
  return size

method calcAutoSize*(self: ScrollViewLayout, exclusions: seq[Component] = @[]): Size =
  var size = procCall self.DefaultLayout.calcAutoSize(exclusions)
  # Add scrollbar sizes if they are to be shown
  return size
