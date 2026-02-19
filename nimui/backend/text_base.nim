import nimui/core/types
import nimui/core/text_data
import nimui/assets/font_info
import nimui/styles/style
import nimui/data/data_source

type
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
    dataSource*: DataSource[string]

proc initTextBase*(self: TextBase) =
  self.displayData = newTextDisplayData()
  self.inputData = newTextInputData()
  self.left = 0
  self.top = 0
  self.width = 0
  self.height = 0
  self.textWidth = 0
  self.textHeight = 0

method focus*(self: TextBase) {.base.} = discard
method blur*(self: TextBase) {.base.} = discard
method dispose*(self: TextBase) {.base.} =
  self.parentComponent = nil

method supportsHtml*(self: TextBase): bool {.base.} = false
method caretIndex*(self: TextBase): int {.base.} = 0
method `caretIndex=`*(self: TextBase, val: int) {.base.} = discard

method validateData*(self: TextBase) {.base.} = discard
method validateStyle*(self: TextBase): bool {.base.} = false
method validatePosition*(self: TextBase) {.base.} = discard
method validateDisplay*(self: TextBase) {.base.} = discard
method measureText*(self: TextBase) {.base.} = discard

method measureTextWidth*(self: TextBase): float {.base.} =
  # Expensive fallback logic from HaxeUI
  return self.textWidth
