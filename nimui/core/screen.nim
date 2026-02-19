import nimui/backend/screen_impl
import nimui/core/types
import nimui/events/ui_event
import nimui/events/mouse_event
import nimui/focus/focus_manager
import nimui/util/event_map

type
  Screen* = ref object of ScreenImpl
    eventMap: EventMap
    currentMouseX*: float
    currentMouseY*: float
    rootComponents*: seq[Component]
    pausedEvents: seq[string]

var screenInstance: Screen

proc instance*(): Screen =
  if screenInstance == nil:
    new screenInstance
    screenInstance.eventMap = newEventMap()
    screenInstance.rootComponents = @[]
    screenInstance.pausedEvents = @[]

    screenInstance.registerEvent(MouseEvent.MOUSE_MOVE, proc(e: UIEvent) =
      let me = cast[MouseEvent](e)
      screenInstance.currentMouseX = me.screenX
      screenInstance.currentMouseY = me.screenY
    )
  return screenInstance

method addComponent*(self: Screen, component: Component): Component =
  # component.hasScreen = true
  # procCall self.ScreenImpl.addComponent(component)
  # component.ready()
  if self.rootComponents.find(component) == -1:
    self.rootComponents.add(component)

  # FocusManager.instance.pushView(component)
  # component.registerEvent(UIEvent.RESIZE, ...)
  return component

method removeComponent*(self: Screen, component: Component, dispose: bool = true, invalidate: bool = true): Component =
  if component == nil: return nil

  let idx = self.rootComponents.find(component)
  if idx == -1:
    if dispose:
      # component.disposeComponent()
      discard
    return component

  self.rootComponents.delete(idx)
  # FocusManager.instance.removeView(component)

  if dispose:
    # component.disposeComponent()
    discard
  else:
    self.dispatch(newUIEvent("hidden"))
  return component

method findComponent*(self: Screen, criteria: string = "", recursive: bool = true): Component {.base.} =
  for r in self.rootComponents:
    # let res = r.findComponent(criteria, nil, recursive)
    # if res != nil: return res
    discard
  return nil

method registerEvent*(self: Screen, typ: string, listener: proc(e: UIEvent), priority: int = 0) {.base.} =
  if self.eventMap.add(typ, listener, priority):
    # self.mapEvent(typ, ...)
    discard

method unregisterEvent*(self: Screen, typ: string, listener: proc(e: UIEvent)) {.base.} =
  if self.eventMap.remove(typ, listener):
    # self.unmapEvent(typ, ...)
    discard

method dispatch*(self: Screen, event: UIEvent) {.base.} =
  if self.pausedEvents.find(event.typ) != -1:
    return
  self.eventMap.invoke(event.typ, event)
