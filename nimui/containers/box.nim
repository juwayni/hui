import nimui/core/types
import nimui/core/component
import nimui/core/composite_builder
import nimui/core/item_renderer
import nimui/data/data_source
import nimui/behaviours/data_behaviour
import nimui/behaviours/default_behaviour
import nimui/layouts/default_layout
import nimui/layouts/layout_factory
import nimui/util/variant
import std/options

type
  Box* = ref object of Component
    hasDataSourceInternal*: bool
    itemRendererInternal*: ItemRenderer
    layoutNameInternal*: string
    cacheItemRenderersInternal*: bool

proc newBox*(): Box =
  new result
  initComponent(result)
  result.cacheItemRenderersInternal = true

method itemRenderer*(self: Box): ItemRenderer {.base.} =
  return self.itemRendererInternal

method `itemRenderer=`*(self: Box, value: ItemRenderer) {.base.} =
  if self.itemRendererInternal != value:
    self.itemRendererInternal = value
    self.invalidateComponentLayout()

method layoutName*(self: Box): string {.base.} =
  return self.layoutNameInternal

method `layoutName=`*(self: Box, value: string) {.base.} =
  if self.layoutNameInternal == value:
    return
  self.layoutNameInternal = value
  let l = createLayoutFromName(value)
  if l != nil:
    self.layoutInternal = l
    self.layoutInternal.component = self

# Behaviours
type
  BoxDataSourceBehaviour* = ref object of DataBehaviour

method set*(self: BoxDataSourceBehaviour, value: Variant) =
  procCall self.DataBehaviour.set(value)
  let box = cast[Box](self.component)
  if value.kind == vkDataSource:
    box.hasDataSourceInternal = true
    value.toDataSource().onDataSourceChange = proc() {.gcsafe.} =
      box.invalidateComponentData()
  else:
    box.hasDataSourceInternal = false
    box.removeAllComponents()
  box.invalidateComponentData()

method get*(self: BoxDataSourceBehaviour): Variant =
  if self.valueInternal.kind == vkNull:
    # self.valueInternal = toVariant(newArrayDataSource[Variant]())
    # ...
    discard
  return self.valueInternal

# Builder
type
  BoxBuilder* = ref object of CompositeBuilder

method addComponent*(self: BoxBuilder, child: Component): Component =
  let box = cast[Box](self.component)
  if (child of ItemRenderer) and box.itemRendererInternal == nil:
    if box.hasDataSourceInternal:
      box.itemRendererInternal = cast[ItemRenderer](child)
      # child.ready()
      box.invalidateComponentData()
      return child
  return procCall self.CompositeBuilder.addComponent(child)

method validateComponentData*(self: BoxBuilder) =
  # Sync children with data source
  discard

method createBuilder*(self: Box): CompositeBuilder =
  return BoxBuilder(component: self)
