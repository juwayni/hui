import nimui/core/types
import nimui/geom/size
import std/options

proc component*(self: Layout): Component = self.componentInternal
proc `component=`*(self: Layout, value: Component) = self.componentInternal = value

method resizeChildren*(self: Layout) {.base.} = discard
method repositionChildren*(self: Layout) {.base.} = discard
method calcAutoSize*(self: Layout, exclusions: seq[Component] = @[]): Size {.base.} = return newSize()

method refreshLayout*(self: Layout) {.base.} =
  if self.component == nil: return
  self.resizeChildren()
  self.repositionChildren()

proc paddingLeft*(self: Layout): float =
  if self.component == nil or self.component.styleInternal == nil: return 0
  return self.component.styleInternal.paddingLeft.get(0)

proc paddingTop*(self: Layout): float =
  if self.component == nil or self.component.styleInternal == nil: return 0
  return self.component.styleInternal.paddingTop.get(0)

proc paddingBottom*(self: Layout): float =
  if self.component == nil or self.component.styleInternal == nil: return 0
  return self.component.styleInternal.paddingBottom.get(0)

proc paddingRight*(self: Layout): float =
  if self.component == nil or self.component.styleInternal == nil: return 0
  return self.component.styleInternal.paddingRight.get(0)

proc horizontalSpacing*(self: Layout): float =
  if self.component == nil or self.component.styleInternal == nil: return 0
  return self.component.styleInternal.horizontalSpacing.get(0)

proc verticalSpacing*(self: Layout): float =
  if self.component == nil or self.component.styleInternal == nil: return 0
  return self.component.styleInternal.verticalSpacing.get(0)

proc innerWidth*(self: Layout): float =
  if self.component == nil: return 0
  return self.component.widthInternal - (self.paddingLeft + self.paddingRight)

proc innerHeight*(self: Layout): float =
  if self.component == nil: return 0
  return self.component.heightInternal - (self.paddingTop + self.paddingBottom)

proc usableSize*(self: Layout): Size =
  return newSize(self.innerWidth, self.innerHeight)
