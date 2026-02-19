import ./function_array
import nimui/events/ui_event
import nimui/core/types
import tables

type
  EventMap* = ref object of RootObj
    map: TableRef[string, FunctionArray[proc(e: UIEvent) {.gcsafe.}]]

proc newEventMap*(): EventMap =
  new result
  result.map = newTable[string, FunctionArray[proc(e: UIEvent) {.gcsafe.}]]()

proc add*(self: EventMap, eventType: string, listener: proc(e: UIEvent) {.gcsafe.}, priority: int = 0): bool =
  var fa: FunctionArray[proc(e: UIEvent) {.gcsafe.}]
  var isNew = false
  if not self.map.hasKey(eventType):
    fa = newFunctionArray[proc(e: UIEvent) {.gcsafe.}]()
    self.map[eventType] = fa
    isNew = true
  else:
    fa = self.map[eventType]

  if not fa.contains(listener):
    fa.push(listener, priority)

  return isNew

proc remove*(self: EventMap, eventType: string, listener: proc(e: UIEvent) {.gcsafe.}): bool =
  if self.map.hasKey(eventType):
    let fa = self.map[eventType]
    let removed = fa.remove(listener)
    if fa.len == 0:
      self.map.del(eventType)
      return true
  return false

proc contains*(self: EventMap, eventType: string, listener: proc(e: UIEvent) {.gcsafe.} = nil): bool =
  if self.map.hasKey(eventType):
    if listener == nil: return true
    return self.map[eventType].contains(listener)
  return false

proc invoke*(self: EventMap, eventType: string, event: UIEvent, target: Component = nil) =
  if self.map.hasKey(eventType):
    let fa = self.map[eventType].copy()
    for listener in fa:
      if event.canceled: break
      listener.callback(event)
