import nimui/core/types
import nimui/core/component
import nimui/core/screen
import nimui/dragdrop/drag_options
import nimui/events/drag_event
import nimui/events/mouse_event
import nimui/events/ui_event
import nimui/geom/point
import nimui/geom/rectangle
import nimui/util/math_util
import std/tables

type
  DragManager* = ref object
    dragComponents: Table[Component, DragOptions]
    mouseTargetToDragTarget: Table[Component, Component]
    currentComponent: Component
    currentOptions: DragOptions
    mouseOffset: Point

var dragManagerInstance: DragManager

proc instance*(): DragManager =
  if dragManagerInstance == nil:
    new dragManagerInstance
    dragManagerInstance.dragComponents = initTable[Component, DragOptions]()
    dragManagerInstance.mouseTargetToDragTarget = initTable[Component, Component]()
    dragManagerInstance.mouseOffset = newPoint(0, 0)
  return dragManagerInstance

proc isDragging*(self: DragManager): bool =
  return self.currentComponent != nil

proc registerDraggable*(self: DragManager, component: Component, options: DragOptions = nil): DragOptions =
  if self.dragComponents.hasKey(component): return nil

  var dragOptions = options
  if dragOptions == nil: dragOptions = newDragOptions()
  if dragOptions.mouseTarget == nil: dragOptions.mouseTarget = component

  self.dragComponents[component] = dragOptions
  self.mouseTargetToDragTarget[dragOptions.mouseTarget] = component

  # Forward declaration or direct call?
  # component.registerEvent(MouseEvent.MOUSE_DOWN, ...)
  return dragOptions

proc unregisterDraggable*(self: DragManager, component: Component) =
  if not self.dragComponents.hasKey(component): return

  let options = self.dragComponents[component]
  self.dragComponents.del(component)
  if options.mouseTarget != nil:
    self.mouseTargetToDragTarget.del(options.mouseTarget)
