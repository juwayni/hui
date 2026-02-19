type
  ToolkitOptions* = ref object
    noBatch*: bool
    showFPS*: bool
    flattenAssetPaths*: bool
    # mouseInput: MouseInputOptions
    # keyboardInput: KeyboardInputOptions

proc newToolkitOptions*(): ToolkitOptions =
  new result
  result.noBatch = false
  result.showFPS = false
  result.flattenAssetPaths = false
