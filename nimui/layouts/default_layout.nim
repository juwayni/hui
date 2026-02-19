import nimui/layouts/layout
import nimui/core/types
import nimui/geom/size
import std/options

type
  DefaultLayout* = ref object of Layout

proc newDefaultLayout*(): DefaultLayout =
  new result

method repositionChild*(self: DefaultLayout, child: Component) {.base.} =
  if child == nil: return

  var xpos = 0.0
  var ypos = 0.0
  let us = self.usableSize()

  case self.horizontalAlign(child):
    of "center":
      xpos = ((us.width - child.widthInternal) / 2.0) + self.paddingLeft() + self.marginLeft(child) - self.marginRight(child)
    of "right":
      xpos = self.component.widthInternal - (child.widthInternal + self.paddingRight() + self.marginRight(child))
    else:
      xpos = self.paddingLeft() + self.marginLeft(child)

  case self.verticalAlign(child):
    of "center":
      ypos = ((us.height - child.heightInternal) / 2.0) + self.paddingTop() + self.marginTop(child) - self.marginBottom(child)
    of "bottom":
      ypos = self.component.heightInternal - (child.heightInternal + self.paddingBottom() + self.marginBottom(child))
    else:
      ypos = self.paddingTop() + self.marginTop(child)

  # child.moveComponent(xpos, ypos)
  child.leftInternal = xpos
  child.topInternal = ypos

method resizeChildren*(self: DefaultLayout) =
  let us = self.usableSize()
  for child in self.component.childComponents:
    if not child.includeInLayout: continue

    var cx = child.widthInternal
    var cy = child.heightInternal

    if child.percentWidthInternal.isSome:
      cx = (us.width * child.percentWidthInternal.get()) / 100.0 - self.marginLeft(child) - self.marginRight(child)
    if child.percentHeightInternal.isSome:
      cy = (us.height * child.percentHeightInternal.get()) / 100.0 - self.marginTop(child) - self.marginBottom(child)

    # child.resizeComponent(cx, cy)
    child.widthInternal = cx
    child.heightInternal = cy

method repositionChildren*(self: DefaultLayout) =
  for child in self.component.childComponents:
    if not child.includeInLayout: continue
    self.repositionChild(child)
