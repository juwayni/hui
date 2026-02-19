import nimui/core/types
import nimui/events/ui_event
import nimui/util/event_map

type
  EventDispatcher* = ref object of RootObj
    eventMap: EventMap

proc initEventDispatcher*(self: EventDispatcher) =
  self.eventMap = newEventMap()

proc newEventDispatcher*(): EventDispatcher =
  new result
  result.initEventDispatcher()

method registerEvent*(self: EventDispatcher, typ: string, listener: proc(e: UIEvent) {.gcsafe.}, priority: int = 0) {.base.} =
  discard self.eventMap.add(typ, listener, priority)

method hasEvent*(self: EventDispatcher, typ: string, listener: proc(e: UIEvent) {.gcsafe.} = nil): bool {.base.} =
  return self.eventMap.contains(typ, listener)

method unregisterEvent*(self: EventDispatcher, typ: string, listener: proc(e: UIEvent) {.gcsafe.}) {.base.} =
  discard self.eventMap.remove(typ, listener)

method dispatch*(self: EventDispatcher, event: UIEvent, target: Component = nil) {.base.} =
  if event.target == nil: event.target = target
  self.eventMap.invoke(event.typ, event, target)

method removeAllListeners*(self: EventDispatcher) {.base.} =
  self.eventMap.removeAll()
