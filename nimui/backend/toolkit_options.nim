import windy

type
  MouseListenerCallback* = proc(
    onMouseDown: proc(button: int, x, y: int) {.closure.},
    onMouseUp: proc(button: int, x, y: int) {.closure.},
    onMouseMove: proc(x, y, dx, dy: int) {.closure.},
    onMouseWheel: proc(delta: int) {.closure.},
    onMouseOut: proc() {.closure.}
  )

  MouseInputOptions* = object
    listen*: MouseListenerCallback
    unlisten*: MouseListenerCallback

  KeyListenerCallback* = proc(
    onKeyDown: proc(key: Button) {.closure.},
    onKeyUp: proc(key: Button) {.closure.},
    onKeyChar: proc(character: string) {.closure.}
  )

  KeyboardInputOptions* = object
    listen*: KeyListenerCallback
    unlisten*: KeyListenerCallback

  ToolkitOptions* = object
    noBatch*: bool
    showFPS*: bool
    flattenAssetPaths*: bool
    mouseInput*: MouseInputOptions
    keyboardInput*: KeyboardInputOptions
