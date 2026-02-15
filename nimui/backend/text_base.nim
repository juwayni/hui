import nimui/core/component
import nimui/assets/font_info
import nimui/styles/style

type
  TextDisplayData* = object
    multiline*: bool
    wordWrap*: bool
    selectable*: bool

  TextInputData* = object
    password*: bool

  TextBase* = ref object of RootObj
    parentComponent*: Component
    text*: string
    htmlText*: string
    left*: float
    top*: float
    width*: float
    height*: float
    textWidth*: float
    textHeight*: float
    textStyle*: Style
    fontInfo*: FontInfo
    displayData*: TextDisplayData
    inputData*: TextInputData

proc newTextBase*(): TextBase =
  TextBase()

method focus*(self: TextBase) {.base.} = discard
method blur*(self: TextBase) {.base.} = discard
method dispose*(self: TextBase) {.base.} = discard

method validateData*(self: TextBase) {.base.} = discard
method validateStyle*(self: TextBase): bool {.base.} = return false
method validatePosition*(self: TextBase) {.base.} = discard
method validateDisplay*(self: TextBase) {.base.} = discard
method measureText*(self: TextBase) {.base.} = discard
