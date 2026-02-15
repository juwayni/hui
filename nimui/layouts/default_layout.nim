import nimui/layouts/layout
import nimui/core/types
import nimui/geom/size
import std/options
import std/tables

type
  DefaultLayout* = ref object of Layout
    calcFullWidths*: bool
    calcFullHeights*: bool
    roundFullWidths*: bool

proc newDefaultLayout*(): DefaultLayout =
  new result
  result.calcFullWidths = false
  result.calcFullHeights = false
  result.roundFullWidths = false

method resizeChildren*(self: DefaultLayout) =
  let usableSize = self.usableSize
  var fullWidthValue = 100.0
  var fullHeightValue = 100.0

  if self.calcFullWidths or self.calcFullHeights:
    var n1 = 0
    var n2 = 0
    for child in self.component.childComponents:
      if not child.includeInLayout: continue
      if child.styleInternal.percentWidth.isSome and child.styleInternal.percentWidth.get == 100:
        n1 += 1
      if child.styleInternal.percentHeight.isSome and child.styleInternal.percentHeight.get == 100:
        n2 += 1

    if n1 > 0: fullWidthValue = 100.0 / n1.float
    if n2 > 0: fullHeightValue = 100.0 / n2.float

  for child in self.component.childComponents:
    if not child.includeInLayout: continue

    var cx = none(float)
    var cy = none(float)

    if child.styleInternal.percentWidth.isSome:
      var cpw = child.styleInternal.percentWidth.get
      if cpw == 100: cpw = fullWidthValue
      cx = some((usableSize.width * cpw) / 100.0)

    if child.styleInternal.percentHeight.isSome:
      var cph = child.styleInternal.percentHeight.get
      if cph == 100: cph = fullHeightValue
      cy = some((usableSize.height * cph) / 100.0)

    if cx.isSome: child.widthInternal = cx.get
    if cy.isSome: child.heightInternal = cy.get

method repositionChildren*(self: DefaultLayout) =
  let usableSize = self.usableSize
  for child in self.component.childComponents:
    if not child.includeInLayout: continue

    var xpos = 0.0
    var ypos = 0.0

    let halign = child.styleInternal.horizontalAlign.get("left")
    case halign:
      of "center":
        xpos = (usableSize.width - child.widthInternal) / 2 + self.paddingLeft
      of "right":
        xpos = self.component.widthInternal - child.widthInternal - self.paddingRight
      else:
        xpos = self.paddingLeft

    let valign = child.styleInternal.verticalAlign.get("top")
    case valign:
      of "center":
        ypos = (usableSize.height - child.heightInternal) / 2 + self.paddingTop
      of "bottom":
        ypos = self.component.heightInternal - child.heightInternal - self.paddingBottom
      else:
        ypos = self.paddingTop

    child.leftInternal = xpos
    child.topInternal = ypos
