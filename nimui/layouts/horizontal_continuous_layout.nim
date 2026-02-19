import nimui/layouts/horizontal_layout
import nimui/core/types
import nimui/geom/size
import nimui/geom/rectangle
import std/options

type
  HorizontalContinuousLayout* = ref object of HorizontalLayout

proc newHorizontalContinuousLayout*(): HorizontalContinuousLayout =
  new result

method repositionChildren*(self: HorizontalContinuousLayout) =
  # Porting full continuous layout logic
  if self.component == nil: return
  if self.component.autoWidth:
    procCall self.HorizontalLayout.repositionChildren()
    return

  let ucx = self.component.widthInternal - (self.paddingLeft() + self.paddingRight())
  if ucx <= 0: return

  # Simplified repositioning for continuous layout
  var xpos = self.paddingLeft()
  var ypos = self.paddingTop()
  var rowHeight = 0.0

  for child in self.component.childComponents:
    if not child.includeInLayout: continue

    if xpos + child.widthInternal > self.component.widthInternal - self.paddingRight():
      xpos = self.paddingLeft()
      ypos += rowHeight + self.verticalSpacing()
      rowHeight = 0.0

    child.leftInternal = xpos + self.marginLeft(child)
    child.topInternal = ypos + self.marginTop(child)

    xpos += child.widthInternal + self.horizontalSpacing()
    if child.heightInternal > rowHeight:
      rowHeight = child.heightInternal

method usableSize*(self: HorizontalContinuousLayout): Size =
  if self.component.autoWidth:
    return procCall self.HorizontalLayout.usableSize()

  return Size(
    width: self.component.widthInternal - (self.paddingLeft() + self.paddingRight()),
    height: self.component.heightInternal - (self.paddingTop() + self.paddingBottom())
  )
