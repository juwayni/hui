import nimui/core/types
import nimui/validation/ivalidating
import nimui/util/event_map
import nimui/events/ui_event
import nimui/events/validation_event
import nimui/toolkit
import std/algorithm

type
  ValidationManager* = ref object
    isValidating*: bool
    isPending*: bool
    queue: seq[IValidating]
    displayQueue: seq[Component]
    events: EventMap

var validationManagerInstance: ValidationManager

proc instance*(): ValidationManager =
  if validationManagerInstance == nil:
    new validationManagerInstance
    validationManagerInstance.queue = @[]
    validationManagerInstance.displayQueue = @[]
    validationManagerInstance.events = newEventMap()
  return validationManagerInstance

proc process*(self: ValidationManager) {.gcsafe.}

proc add*(self: ValidationManager, obj: IValidating) {.gcsafe.} =
  if self.queue.find(obj) != -1: return
  self.queue.add(obj)
  if not self.isPending:
    self.isPending = true
    # callLater(proc() = self.process())
    discard

proc process*(self: ValidationManager) =
  if self.isValidating or not self.isPending: return
  if self.queue.len == 0:
    self.isPending = false
    return

  self.isValidating = true
  # Sort queue by depth
  self.queue.sort(proc(x, y: IValidating): int =
    return y.depth() - x.depth()
  )

  while self.queue.len > 0:
    let item = self.queue[0]
    self.queue.delete(0)
    item.validateComponent()

  for item in self.displayQueue:
    item.updateComponentDisplay()
  self.displayQueue = @[]

  self.isValidating = false
  self.isPending = false
