import nimui/core/types
import nimui/geom/size
import std/options

# Forward declarations or inclusions of Component methods
# Since Component is in types.nim, we can use it here.

method applyProperties*(self: Layout, props: seq[(string, string)]) {.base.} = discard

method refresh*(self: Layout) {.base.} =
  if self.component != nil and self.component.isReadyInternal:
    self.resizeChildren()
    # self.component.handlePreReposition()
    self.repositionChildren()
    # self.component.handlePostReposition()

method resizeChildren*(self: Layout) {.base.} = discard
method repositionChildren*(self: Layout) {.base.} = discard

method paddingLeft*(self: Layout): float {.base.} =
  if self.component == nil or self.component.styleInternal == nil: return 0.0
  return self.component.styleInternal.paddingLeft.get(0.0)

method paddingTop*(self: Layout): float {.base.} =
  if self.component == nil or self.component.styleInternal == nil: return 0.0
  return self.component.styleInternal.paddingTop.get(0.0)

method paddingRight*(self: Layout): float {.base.} =
  if self.component == nil or self.component.styleInternal == nil: return 0.0
  return self.component.styleInternal.paddingRight.get(0.0)

method paddingBottom*(self: Layout): float {.base.} =
  if self.component == nil or self.component.styleInternal == nil: return 0.0
  return self.component.styleInternal.paddingBottom.get(0.0)

method horizontalSpacing*(self: Layout): float {.base.} =
  if self.component == nil or self.component.styleInternal == nil: return 0.0
  return self.component.styleInternal.horizontalSpacing.get(0.0)

method verticalSpacing*(self: Layout): float {.base.} =
  if self.component == nil or self.component.styleInternal == nil: return 0.0
  return self.component.styleInternal.verticalSpacing.get(0.0)

method marginLeft*(self: Layout, child: Component): float {.base.} =
  if child == nil or child.styleInternal == nil: return 0.0
  return child.styleInternal.marginLeft.get(0.0)

method marginTop*(self: Layout, child: Component): float {.base.} =
  if child == nil or child.styleInternal == nil: return 0.0
  return child.styleInternal.marginTop.get(0.0)

method marginRight*(self: Layout, child: Component): float {.base.} =
  if child == nil or child.styleInternal == nil: return 0.0
  return child.styleInternal.marginRight.get(0.0)

method marginBottom*(self: Layout, child: Component): float {.base.} =
  if child == nil or child.styleInternal == nil: return 0.0
  return child.styleInternal.marginBottom.get(0.0)

method horizontalAlign*(self: Layout, child: Component): string {.base.} =
  if child == nil or child.styleInternal == nil: return "left"
  return child.styleInternal.horizontalAlign.get("left")

method verticalAlign*(self: Layout, child: Component): string {.base.} =
  if child == nil or child.styleInternal == nil: return "top"
  return child.styleInternal.verticalAlign.get("top")

method usableSize*(self: Layout): Size {.base.} =
  var w = 0.0
  if self.component != nil:
    w = self.component.widthInternal - (self.paddingLeft() + self.paddingRight())
  var h = 0.0
  if self.component != nil:
    h = self.component.heightInternal - (self.paddingTop() + self.paddingBottom())
  return Size(width: w, height: h)

method calcAutoSize*(self: Layout, exclusions: seq[Component] = @[]): Size {.base.} =
  var x1 = 1000000.0
  var x2 = 0.0
  var y1 = 1000000.0
  var y2 = 0.0

  if self.component == nil: return Size(width: 0, height: 0)

  for child in self.component.childComponents:
    if not child.includeInLayout: continue

    if child.percentWidthInternal.isNone:
      let l = child.leftInternal - self.marginLeft(child) + self.marginRight(child)
      if l < x1: x1 = l
      let r = child.leftInternal + child.widthInternal - self.marginLeft(child) + self.marginRight(child)
      if r > x2: x2 = r

    if child.percentHeightInternal.isNone:
      let t = child.topInternal - self.marginTop(child) + self.marginBottom(child)
      if t < y1: y1 = t
      let b = child.topInternal + child.heightInternal - self.marginTop(child) + self.marginBottom(child)
      if b > y2: y2 = b

  if x1 == 1000000.0: x1 = 0.0
  if y1 == 1000000.0: y1 = 0.0

  let w = (x2 - x1) + (self.paddingLeft() + self.paddingRight())
  let h = (y2 - y1) + (self.paddingTop() + self.paddingBottom())

  return Size(width: w, height: h)
