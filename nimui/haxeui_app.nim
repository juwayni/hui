import nimui/backend/app_impl
import nimui/backend/toolkit_options
import nimui/core/component
import nimui/core/screen
import nimui/toolkit
import nimui/toolkit_assets
import nimui/preloader
import std/options

type
  HaxeUIApp* = ref object of AppImpl
    optionsInternal: ToolkitOptions
    readyCalled: bool
    onReadyInternal: proc() {.gcsafe.}
    onEndInternal: proc() {.gcsafe.}
    preloaderInternal*: Preloader

var gInstance: HaxeUIApp

proc instance*(): HaxeUIApp = gInstance

proc newHaxeUIApp*(options: ToolkitOptions = ToolkitOptions()): HaxeUIApp =
  let impl = newAppImpl()
  result = HaxeUIApp(
    eventsInternal: impl.eventsInternal,
    autoHandlePreloadInternal: impl.autoHandlePreloadInternal,
    backgroundColor: impl.backgroundColor,
    optionsInternal: options
  )
  gInstance = result
  Toolkit.build()
  result.build()

method startPreload(self: HaxeUIApp, onComplete: proc() {.gcsafe.}) =
  # Preload logic
  onComplete()

method init*(self: HaxeUIApp, onReady: proc() {.gcsafe.}, onEnd: proc() {.gcsafe.} = nil) =
  self.onReadyInternal = onReady
  self.onEndInternal = onEnd

  Toolkit.init(self.optionsInternal)

  if self.autoHandlePreloadInternal:
    self.startPreload(proc() =
      procCall self.AppImpl.init(self.onReadyInternal, self.onEndInternal)
    )
  else:
    procCall self.AppImpl.init(self.onReadyInternal, self.onEndInternal)

proc ready*(self: HaxeUIApp, onReady: proc() {.gcsafe.}, onEnd: proc() {.gcsafe.} = nil) =
  if self.readyCalled:
    onReady()
    return
  self.readyCalled = true
  self.init(onReady, onEnd)

proc title*(self: HaxeUIApp): string = screen().title()
proc `title=`*(self: HaxeUIApp, value: string) = screen().title = value

proc addComponent*(self: HaxeUIApp, component: Component): Component =
  screen().addComponent(component)

proc removeComponent*(self: HaxeUIApp, component: Component, dispose: bool = true): Component =
  screen().removeComponent(component, dispose)
