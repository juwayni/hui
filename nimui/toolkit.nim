import nimui/backend/toolkit_options
import nimui/core/screen
import nimui/core/types
import nimui/toolkit_assets
import nimui/styles/composite_style_sheet
import nimui/themes/theme_manager
import nimui/locale/locale_manager
import nimui/focus/focus_manager
import nimui/util/properties
import nimui/util/generic_config
import nimui/util/defines
import nimui/macros/native_macros
import nimui/macros/backend_macros
import nimui/call_later
import std/tables
import std/math

type
  Toolkit* = object

var
  gStyleSheet: CompositeStyleSheet
  gProperties: TableRef[string, string]
  gNativeConfig: GenericConfig
  gTheme: string = "default"
  gInitialized: bool = false
  gBuilt: bool = false
  gBackendBuilt: bool = false
  gBackendProperties: Properties
  gPixelsPerRem: int = 16
  gRoundScale: bool = true
  gAutoScale: bool = true
  gScaleX: float = 0
  gScaleY: float = 0

proc styleSheet*(): CompositeStyleSheet =
  return composite_style_sheet.instance()

proc assets*(): ToolkitAssets = ToolkitAssets.instance()
proc screen*(): Screen = Screen.instance()

proc buildBackend() =
  if gBackendBuilt: return
  processBackend()
  gBackendBuilt = true

proc build*() =
  if gBuilt: return
  # ModuleMacros.processModules() placeholder
  processNative()
  buildBackend()
  LocaleManager.instance().init()
  gBuilt = true

proc init*(options: ToolkitOptions = ToolkitOptions()) =
  build()
  ThemeManager.instance().applyTheme(gTheme)
  screen().optionsInternal = options
  assets().options = options
  gInitialized = true

proc scaleX*(): float =
  if gScaleX == 0:
    if gAutoScale:
      let dpi = screen().dpi()
      let threshold = if screen().isRetina(): 192.0 else: 120.0
      if dpi > threshold:
        if gRoundScale: gScaleX = round(dpi / threshold)
        else: gScaleX = dpi / threshold
      else: gScaleX = 1.0
    else: gScaleX = 1.0
  return gScaleX

proc scaleY*(): float =
  if gScaleY == 0:
    if gAutoScale:
      let dpi = screen().dpi()
      let threshold = if screen().isRetina(): 192.0 else: 120.0
      if dpi > threshold:
        if gRoundScale: gScaleY = round(dpi / threshold)
        else: gScaleY = dpi / threshold
      else: gScaleY = 1.0
    else: gScaleY = 1.0
  return gScaleY

proc scale*(): float = max(scaleX(), scaleY())

proc callLater*(fn: proc() {.gcsafe.}) =
  discard newCallLater(fn)

proc pixelsPerRem*(): int = gPixelsPerRem
proc `pixelsPerRem=`*(value: int) =
  if gPixelsPerRem == value: return
  gPixelsPerRem = value
  screen().refreshStyleRootComponents()

proc theme*(): string = gTheme
proc `theme=`*(value: string) =
  if gTheme == value: return
  gTheme = value
  if gInitialized:
    ThemeManager.instance().applyTheme(gTheme)
    screen().onThemeChanged()
    screen().invalidateAll()
