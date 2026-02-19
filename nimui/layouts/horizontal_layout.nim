import nimui/layouts/default_layout
import nimui/core/types
import nimui/geom/size
import std/options

type
  HorizontalLayout* = ref object of DefaultLayout

proc newHorizontalLayout*(): HorizontalLayout =
  new result

method usableSize*(self: HorizontalLayout): Size =
  var size = procCall self.DefaultLayout.usableSize()
  var visibleChildren = 0
  for child in self.component.childComponents:
    if not child.includeInLayout: continue
    visibleChildren += 1
    if child.widthInternal > 0 and child.percentWidthInternal.isNone:
      size.width -= child.widthInternal + self.marginLeft(child) + self.marginRight(child)

  if visibleChildren > 1:
    size.width -= self.horizontalSpacing() * (visibleChildren - 1).float

  if size.width < 0: size.width = 0
  return size

method repositionChildren*(self: HorizontalLayout) =
  var xpos = self.paddingLeft()
  let us = self.usableSize()
  let spacing = self.horizontalSpacing()

  for child in self.component.childComponents:
    if not child.includeInLayout: continue

    var ypos = 0.0
    case self.verticalAlign(child):
      of "center":
        ypos = ((us.height - child.heightInternal) / 2.0) + self.paddingTop() + self.marginTop(child) - self.marginBottom(child)
      of "bottom":
        ypos = self.component.heightInternal - (child.heightInternal + self.paddingBottom() + self.marginBottom(child))
      else:
        ypos = self.paddingTop() + self.marginTop(child)

    child.leftInternal = xpos + self.marginLeft(child)
    child.topInternal = ypos
    xpos += child.widthInternal + spacing
