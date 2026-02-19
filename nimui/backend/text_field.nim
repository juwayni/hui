import nimui/core/types
import nimui/backend/font_data
import nimui/util/color
import std/strutils
import std/math

type
  CharPosition* = object
    row*: int
    column*: int

  CaretInfo* = object
    row*, column*: int
    visible*: bool
    force*: bool
    timerId*: int

  SelectionInfo* = object
    start*: CharPosition
    `end`*: CharPosition

  TextField* = ref object of RootObj
    id*: string
    left*, top*: float
    width*, height*: float
    textInternal*: string
    editable*: bool
    textColor*: Color
    backgroundColor*: Color
    selectedTextColor*: Color
    selectedBackgroundColor*: Color
    scrollTop*: int
    scrollLeft*: float
    password*: bool
    font*: FontData
    fontSize*: int
    multiline*: bool
    wordWrap*: bool
    autoHeight*: bool
    caretInfo*: CaretInfo
    selectionInfo*: SelectionInfo
    lines*: seq[seq[int]]
    textChangedCallbacks*: seq[proc(s: string) {.gcsafe.}]
    caretMovedCallbacks*: seq[proc(p: CaretInfo) {.gcsafe.}]

proc newTextField*(): TextField =
  new result
  result.width = 200
  result.height = 100
  result.textColor = color(0, 0, 0, 255)
  result.backgroundColor = color(255, 255, 255, 255)
  result.selectedTextColor = color(255, 255, 255, 255)
  result.selectedBackgroundColor = color(51, 144, 255, 255)
  result.editable = true
  result.fontSize = 14
  result.multiline = true
  result.wordWrap = true
  result.caretInfo = CaretInfo(row: -1, column: -1, visible: false, timerId: -1)
  result.selectionInfo = SelectionInfo(start: CharPosition(row: -1, column: -1), `end`: CharPosition(row: -1, column: -1))

method text*(self: TextField): string {.base.} = self.textInternal
method `text=`*(self: TextField, value: string) {.base.} =
  if self.textInternal == value: return
  self.textInternal = value
  # recalc()
  for cb in self.textChangedCallbacks: cb(value)

method notify*(self: TextField, textChanged: proc(s: string) {.gcsafe.}, caretMoved: proc(p: CaretInfo) {.gcsafe.}) {.base.} =
  if textChanged != nil: self.textChangedCallbacks.add(textChanged)
  if caretMoved != nil: self.caretMovedCallbacks.add(caretMoved)

# Logic for line splitting, caret movement etc would go here
