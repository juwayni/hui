import nimui/core/types
import nimui/core/component
import nimui/events/ui_event
import nimui/events/mouse_event
import nimui/util/event_map
import nimui/backend/toolkit_options
import windy
import std/options
import std/tables

type
  ScreenBase* = ref object of RootObj
    rootComponents*: seq[Component]
    optionsInternal*: ToolkitOptions
    titleInternal*: string

  ScreenImpl* = ref object of ScreenBase
    windowInternal*: Window
    mapping*: Table[string, proc(e: UIEvent) {.gcsafe.}]
    cursorLocked*: bool

proc newScreenImpl*(): ScreenImpl =
  new result
  result.rootComponents = @[]
  result.mapping = initTable[string, proc(e: UIEvent) {.gcsafe.}]()

proc window*(self: ScreenImpl): Window = self.windowInternal
proc `window=`*(self: ScreenImpl, value: Window) = self.windowInternal = value

method width*(self: ScreenBase): float {.base.} = return 0.0
method height*(self: ScreenBase): float {.base.} = return 0.0

method width*(self: ScreenImpl): float =
  if self.windowInternal != nil: return self.windowInternal.size.x.float
  return 0.0

method height*(self: ScreenImpl): float =
  if self.windowInternal != nil: return self.windowInternal.size.y.float
  return 0.0

method dpi*(self: ScreenBase): float {.base.} = return 72.0

method addComponent*(self: ScreenBase, component: Component): Component {.base.} =
  self.rootComponents.add(component)
  return component

method removeComponent*(self: ScreenBase, component: Component, dispose: bool = true, invalidate: bool = true): Component {.base.} =
  let idx = self.rootComponents.find(component)
  if idx != -1:
    self.rootComponents.delete(idx)
  return component

method handleSetComponentIndex*(self: ScreenBase, child: Component, index: int) {.base.} =
  discard

method supportsEvent*(self: ScreenBase, eventType: string): bool {.base.} =
  return false

method supportsEvent*(self: ScreenImpl, eventType: string): bool =
  case eventType:
    of MouseEventMove, MouseEventDown, MouseEventUp: return true
    else: return false

method mapEvent*(self: ScreenImpl, eventType: string, listener: proc(e: UIEvent) {.gcsafe.}) {.base, gcsafe.} =
  self.mapping[eventType] = listener

method unmapEvent*(self: ScreenImpl, eventType: string, listener: proc(e: UIEvent) {.gcsafe.}) {.base, gcsafe.} =
  self.mapping.del(eventType)

proc resizeRootComponents*(self: ScreenBase) =
  for c in self.rootComponents:
    # resize logic
    discard
