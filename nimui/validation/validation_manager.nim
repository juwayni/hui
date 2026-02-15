import nimui/validation/ivalidating
import nimui/core/types
import nimui/call_later
import algorithm

type
  ValidationManager* = ref object
    isValidating*: bool
    isPending*: bool
    queue: seq[IValidating]
    displayQueue: seq[Component]

var instanceInternal: ValidationManager

proc process*(self: ValidationManager)

proc instance*(): ValidationManager =
  if instanceInternal == nil:
    instanceInternal = ValidationManager(
      isValidating: false,
      isPending: false,
      queue: @[],
      displayQueue: @[]
    )
  return instanceInternal

proc add*(self: ValidationManager, objectToValidate: IValidating) =
  if self.queue.contains(objectToValidate):
    return

  if self.isValidating:
    # insertion with depth order (ascending)
    let depth = objectToValidate.depth
    var i = 0
    while i < self.queue.len:
      if self.queue[i].depth > depth:
        break
      i += 1
    self.queue.insert(objectToValidate, i)
  else:
    self.queue.add(objectToValidate)
    if not self.isPending:
      self.isPending = true
      let s = self
      discard newCallLater(proc() {.gcsafe.} =
        {.cast(gcsafe).}:
          s.process()
      )

proc addDisplay*(self: ValidationManager, item: Component, nextFrame: bool = true) =
  if not self.displayQueue.contains(item):
    self.displayQueue.add(item)
  if not nextFrame:
    self.process()

proc process*(self: ValidationManager) =
  if self.isValidating or not self.isPending:
    return

  if self.queue.len == 0:
    self.isPending = false
    return

  self.isValidating = true
  self.queue.sort(proc (x, y: IValidating): int =
    return x.depth - y.depth
  )

  while self.queue.len > 0:
    let item = self.queue[0]
    self.queue.delete(0)
    if item.depth >= 0:
      item.validateComponent()

  for item in self.displayQueue:
    item.updateComponentDisplay()
  self.displayQueue = @[]

  self.isValidating = false
  if self.queue.len > 0:
    self.isPending = true
    let s = self
    discard newCallLater(proc() {.gcsafe.} =
      {.cast(gcsafe).}:
        s.process()
    )
  else:
    self.isPending = false
