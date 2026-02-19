import nimui/core/types
import nimui/geom/rectangle

type
  DragOptions* = ref object
    mouseTarget*: Component
    dragOffsetX*: float
    dragOffsetY*: float
    dragTolerance*: int
    dragBounds*: Rectangle
    draggableStyleName*: string
    draggingStyleName*: string

proc newDragOptions*(): DragOptions =
  new result
  result.dragOffsetX = 0
  result.dragOffsetY = 0
  result.dragTolerance = 1
  result.draggableStyleName = "draggable"
  result.draggingStyleName = "dragging"
