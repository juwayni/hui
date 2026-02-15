import nimui/backend/toolkit_options
import windy

var listen*: KeyListenerCallback
var unlisten*: KeyListenerCallback

proc isInitialized*(): bool =
  listen != nil

proc init*(opts: KeyboardInputOptions) =
  listen = opts.listen
  unlisten = opts.unlisten

# Helper to bridge Windy events to these callbacks
proc handleKeyDown*(key: Button) =
  if onKeyDown != nil:
    onKeyDown(key)

proc handleKeyUp*(key: Button) =
  if onKeyUp != nil:
    onKeyUp(key)

proc handleKeyChar*(character: string) =
  if onKeyChar != nil:
    onKeyChar(character)

# Actually, in Haxe:
# typedef KeyListenerCallback = (
#    kha.input.KeyCode -> Void,
#    kha.input.KeyCode -> Void,
#    String -> Void
# ) -> Void;
# It's a function that accepts 3 functions.

# So when KeyboardHelper.init is called, it might be called like:
# KeyboardHelper.init({
#    listen: function(down, up, press) { ... }
# })

# In Nim, we can store the 3 callbacks if they were provided.

var onKeyDown*: proc(key: Button) {.closure.}
var onKeyUp*: proc(key: Button) {.closure.}
var onKeyChar*: proc(character: string) {.closure.}

proc initManual*(keyDown: proc(key: Button) {.closure.},
                keyUp: proc(key: Button) {.closure.},
                keyChar: proc(character: string) {.closure.}) =
  onKeyDown = keyDown
  onKeyUp = keyUp
  onKeyChar = keyChar
