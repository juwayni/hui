import nimui/core/types
import nimui/styles/style
import nimui/util/math_util
import nimui/layouts/layout

type
  CompositeBuilder* = ref object of RootObj
    component*: Component

proc newCompositeBuilder*(component: Component): CompositeBuilder =
  new result
  result.component = component

method create*(self: CompositeBuilder) {.base.} = discard
method destroy*(self: CompositeBuilder) {.base.} = discard
method onInitialize*(self: CompositeBuilder) {.base.} = discard
method onReady*(self: CompositeBuilder) {.base.} = discard

method show*(self: CompositeBuilder): bool {.base.} = false
method hide*(self: CompositeBuilder): bool {.base.} = false

method numComponents*(self: CompositeBuilder): int {.base.} = 0 # Returning 0 instead of Null<Int>
method cssName*(self: CompositeBuilder): string {.base.} = ""

method addComponent*(self: CompositeBuilder, child: Component): Component {.base.} = nil
method addComponentAt*(self: CompositeBuilder, child: Component, index: int): Component {.base.} = nil
method removeComponent*(self: CompositeBuilder, child: Component, dispose: bool = true, invalidate: bool = true): Component {.base.} = nil
method removeComponentAt*(self: CompositeBuilder, index: int, dispose: bool = true, invalidate: bool = true): Component {.base.} = nil
method removeAllComponents*(self: CompositeBuilder, dispose: bool = true): bool {.base.} = false

method getComponentIndex*(self: CompositeBuilder, child: Component): int {.base.} =
  return -2147483647 # MathUtil.MIN_INT

method setComponentIndex*(self: CompositeBuilder, child: Component, index: int): Component {.base.} = nil
method getComponentAt*(self: CompositeBuilder, index: int): Component {.base.} = nil

method validateComponentLayout*(self: CompositeBuilder): bool {.base.} = false
method validateComponentData*(self: CompositeBuilder) {.base.} = discard

method applyStyle*(self: CompositeBuilder, style: Style) {.base.} = discard
method onComponentAdded*(self: CompositeBuilder, child: Component) {.base.} = discard
method onComponentRemoved*(self: CompositeBuilder, child: Component) {.base.} = discard

method findComponent*(self: CompositeBuilder, criteria: string, recursive: bool, searchType: string): Component {.base.} =
  for i in 0..<self.numComponents:
    let c = self.getComponentAt(i)
    # let match = c.findComponent(criteria, nil, recursive, searchType)
    # if match != nil: return match
    discard
  return nil

method findComponents*(self: CompositeBuilder, styleName: string = "", maxDepth: int = 5): seq[Component] {.base.} = @[]

method isComponentClipped*(self: CompositeBuilder): bool {.base.} =
  # return self.component.componentClipRect != nil
  return false

method setLayout*(self: CompositeBuilder, value: Layout): Layout {.base.} = nil
