import nimui/backend/toolkit_options
import nimui/events/ui_event
import nimui/util/event_map
import nimui/preloader
import nimui/toolkit

type
  AppBase* = ref object of RootObj
    eventsInternal: EventMap
    autoHandlePreloadInternal*: bool

proc newAppBase*(): AppBase =
  new result
  result.eventsInternal = newEventMap()
  result.autoHandlePreloadInternal = true

method build*(self: AppBase) {.base.} = discard
method init*(self: AppBase, onReady: proc() {.gcsafe.}, onEnd: proc() {.gcsafe.} = nil) {.base.} =
  onReady()

method getToolkitInit*(self: AppBase): ToolkitOptions {.base.} = ToolkitOptions()
method start*(self: AppBase) {.base.} = discard
method exit*(self: AppBase) {.base.} = discard
method buildPreloadList*(self: AppBase): seq[PreloadItem] {.base.} = @[]
method startPreload*(self: AppBase, onComplete: proc() {.gcsafe.}) {.base.} = discard

type
  AppImpl* = ref object of AppBase
    backgroundColor*: int

proc newAppImpl*(): AppImpl =
  let base = newAppBase()
  result = AppImpl(eventsInternal: base.eventsInternal, autoHandlePreloadInternal: base.autoHandlePreloadInternal)
  result.backgroundColor = 0xFFFFFF

method init*(self: AppImpl, callback: proc() {.gcsafe.}, onEnd: proc() {.gcsafe.} = nil) =
  # Windy/Pixie initialization would go here
  callback()
