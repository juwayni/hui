import nimui/layouts/default_layout
import nimui/layouts/layout
import nimui/core/types
import nimui/geom/size
import std/options

type
  HorizontalLayout* = ref object of DefaultLayout

proc newHorizontalLayout*(): HorizontalLayout =
  new result
  result.calcFullWidths = true
  result.roundFullWidths = true

method repositionChildren*(self: HorizontalLayout) =
  var xpos = self.paddingLeft()
  let usableSize = self.usableSize()
  let spacing = self.horizontalSpacing()

  for child in self.component.childComponents:
    if not child.includeInLayout: continue

    var ypos = 0.0
    let valign = child.styleInternal.verticalAlign.get("top")
    case valign:
      of "center":
        ypos = (usableSize.height - child.heightInternal) / 2 + self.paddingTop()
      of "bottom":
        ypos = self.component.heightInternal - child.heightInternal - self.paddingBottom()
      else:
        ypos = self.paddingTop()

    child.leftInternal = xpos
    child.topInternal = ypos
    xpos += child.widthInternal + spacing
