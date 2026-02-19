import nimui/layouts/default_layout
import nimui/core/types
import nimui/geom/size
import std/options
import std/tables

type
  DelegateLayoutSize* = ref object of RootObj
    component*: Component
    config*: Table[string, string]

proc newDelegateLayoutSize*(): DelegateLayoutSize =
  new result
  result.config = initTable[string, string]()

method width*(self: DelegateLayoutSize): float {.base.} = 0.0
method height*(self: DelegateLayoutSize): float {.base.} = 0.0
method usableWidthModifier*(self: DelegateLayoutSize): float {.base.} = 0.0
method usableHeightModifier*(self: DelegateLayoutSize): float {.base.} = 0.0

proc getString*(self: DelegateLayoutSize, name: string, defaultValue: string = ""): string =
  return self.config.getOrDefault(name, defaultValue)

proc getBool*(self: DelegateLayoutSize, name: string, defaultValue: bool = false): bool =
  let v = self.getString(name)
  if v == "": return defaultValue
  return v == "true"

type
  DelegateLayout* = ref object of DefaultLayout
    sizeInternal*: DelegateLayoutSize

proc newDelegateLayout*(size: DelegateLayoutSize = nil): DelegateLayout =
  new result
  result.sizeInternal = size

method calcAutoSize*(self: DelegateLayout, exclusions: seq[Component] = @[]): Size =
  if self.sizeInternal == nil: return procCall self.DefaultLayout.calcAutoSize(exclusions)
  self.sizeInternal.component = self.component

  var cx = self.sizeInternal.width()
  var cy = self.sizeInternal.height()
  if self.sizeInternal.getBool("includePadding", false):
    cx += self.paddingLeft() + self.paddingRight()
    cy += self.paddingTop() + self.paddingBottom()

  return Size(width: cx, height: cy)

method usableSize*(self: DelegateLayout): Size =
  var size = procCall self.DefaultLayout.usableSize()
  if self.sizeInternal != nil:
    self.sizeInternal.component = self.component
    size.width -= self.sizeInternal.usableWidthModifier()
    size.height -= self.sizeInternal.usableHeightModifier()
  return size
