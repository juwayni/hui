import nimui/events/ui_event
import nimui/core/types

type
  IEventDispatcher* = concept x
    x.registerEvent(typ: string, listener: proc(e: UIEvent), priority: int)
    x.hasEvent(typ: string, listener: proc(e: UIEvent)): bool
    x.unregisterEvent(typ: string, listener: proc(e: UIEvent))
    x.dispatch(event: UIEvent, target: Component)
    x.removeAllListeners()
