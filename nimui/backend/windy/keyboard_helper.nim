import nimui/backend/toolkit_options

type
  KeyListenerCallback* = proc(keyCode: int) {.gcsafe.}

var listen*: KeyListenerCallback = nil
var unlisten*: KeyListenerCallback = nil

proc isInitialized*(): bool =
  return listen != nil

proc init*(opts: ToolkitOptions = nil) =
  # Windy specific initialization
  discard
