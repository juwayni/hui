import nimui/core/types
import nimui/core/component
import nimui/containers/box
import nimui/events/ui_event
import nimui/events/mouse_event
import nimui/events/item_event
import nimui/events/item_renderer_event
import nimui/util/variant
import nimui/util/color
import nimui/components/label
import nimui/components/image
import nimui/core/interactive_component
import std/options

proc newItemRenderer*(): ItemRenderer =
  new result
  initComponent(result)
  result.autoRegisterInteractiveEvents = true
  result.recursiveStyling = false
  result.allowLayoutProperties = true
  result.maxRecursionLevel = 5
  result.itemIndex = -1

method _onItemMouseOver(self: ItemRenderer, event: MouseEvent) {.base.} =
  self.addClass(":hover", true, self.recursiveStyling)
  if not self.recursiveStyling:
    for c in self.findComponents("", Label):
      c.addClass(":hover")
    for c in self.findComponents("", Image):
      c.addClass(":hover")

method _onItemMouseOut(self: ItemRenderer, event: MouseEvent) {.base.} =
  self.removeClass(":hover", true, self.recursiveStyling)
  if not self.recursiveStyling:
    for c in self.findComponents("", Label):
      c.removeClass(":hover")
    for c in self.findComponents("", Image):
      c.removeClass(":hover")

method data*(self: ItemRenderer): Variant {.base.} =
  return self.dataInternal

method `data=`*(self: ItemRenderer, value: Variant) {.base.} =
  self.dataInternal = value
  self.invalidateComponentData()

method onDataChanged*(self: ItemRenderer, data: Variant) {.base.} =
  self.dataInternal = data

method onItemChange*(self: ItemRenderer, event: UIEvent) {.base.} =
  if self.itemIndex < 0:
    return

  # Logic to update data from component value
  # ... (omitted for brevity but should be implemented)

  let e = newItemEvent("itemcomponentevent")
  e.bubble = true
  e.source = event.target
  e.sourceEvent = event
  e.itemIndex = self.itemIndex
  e.data = self.dataInternal
  self.dispatch(e)

method onItemClick*(self: ItemRenderer, event: UIEvent) {.base.} =
  if self.itemIndex < 0:
    return

  let e = newItemEvent("itemcomponentevent")
  e.bubble = true
  e.source = event.target
  e.sourceEvent = event
  e.itemIndex = self.itemIndex
  e.data = self.dataInternal
  self.dispatch(e)
  if e.canceled:
    event.cancel()

method updateValues*(self: ItemRenderer, value: Variant, fieldList: seq[string] = @[], currentRecursionLevel: int = 0) {.base.} =
  if currentRecursionLevel > self.maxRecursionLevel:
    return
  # Implementation of updateValues logic...
  discard

method validateComponentData*(self: ItemRenderer) =
  self.updateValues(self.dataInternal)

  if self.autoRegisterInteractiveEvents:
    for c in self.findComponents("", Component):
      if c of InteractiveComponent:
        if not c.hasEvent("change"):
           c.registerEvent("change", proc(e: UIEvent) = self.onItemChange(e))
        if not c.hasEvent("click"):
           c.registerEvent("click", proc(e: UIEvent) = self.onItemClick(e))

  if self.parentComponent != nil:
    # self.parentComponent.assignPositionClasses()
    discard

  self.onDataChanged(self.dataInternal)
  let event = newItemRendererEvent("datachanged")
  event.target = self
  self.dispatch(event)
