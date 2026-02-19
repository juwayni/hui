import nimui/layouts/default_layout
import nimui/core/types
import nimui/geom/size
import std/options

type
  VerticalLayout* = ref object of DefaultLayout

proc newVerticalLayout*(): VerticalLayout =
  new result

method usableSize*(self: VerticalLayout): Size =
  var size = procCall self.DefaultLayout.usableSize()
  var visibleChildren = 0
  for child in self.component.childComponents:
    if not child.includeInLayout: continue
    visibleChildren += 1
    if child.heightInternal > 0 and child.percentHeightInternal.isNone:
      size.height -= child.heightInternal + self.marginTop(child) + self.marginBottom(child)

  if visibleChildren > 1:
    size.height -= self.verticalSpacing() * (visibleChildren - 1).float

  if size.height < 0: size.height = 0
  return size

method repositionChildren*(self: VerticalLayout) =
  var ypos = self.paddingTop()
  let us = self.usableSize()
  let spacing = self.verticalSpacing()

  for child in self.component.childComponents:
    if not child.includeInLayout: continue

    var xpos = 0.0
    case self.horizontalAlign(child):
      of "center":
        xpos = ((us.width - child.widthInternal) / 2.0) + self.paddingLeft() + self.marginLeft(child) - self.marginRight(child)
      of "right":
        xpos = self.component.widthInternal - (child.widthInternal + self.paddingRight() + self.marginRight(child))
      else:
        xpos = self.paddingLeft() + self.marginLeft(child)

    child.leftInternal = xpos
    child.topInternal = ypos + self.marginTop(child)
    ypos += child.heightInternal + spacing
