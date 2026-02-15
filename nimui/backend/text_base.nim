import nimui/assets/font_info
import nimui/core/types

type
  TextDisplayData* = object

  TextInputData* = object

  TextBase* = ref object of RootObj
    parentComponent*: Component
    displayData*: TextDisplayData
    inputData*: TextInputData
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
    dataSource*: RootRef

proc newTextBase*(): TextBase =
  new result
  result.htmlText = ""

method focus*(self: TextBase) {.base.} = discard
method blur*(self: TextBase) {.base.} = discard
method dispose*(self: TextBase) {.base.} =
  self.parentComponent = nil

method validateData*(self: TextBase) {.base.} = discard
method validateStyle*(self: TextBase): bool {.base.} = return false
method validatePosition*(self: TextBase) {.base.} = discard
method validateDisplay*(self: TextBase) {.base.} = discard
method measureText*(self: TextBase) {.base.} = discard

method measureTextWidth*(self: TextBase): float {.base.} =
  # Simplified implementation
  return self.textWidth
