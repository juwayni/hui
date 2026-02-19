import nimui/backend/text_base
import nimui/backend/text_field
import nimui/backend/font_data
import nimui/events/ui_event
import nimui/core/types
import nimui/util/color
import std/options

type
  TextInputImpl* = ref object of TextBase
    tf*: TextField
    font*: FontData
    textAlign*: string
    fontSize*: float
    fontName*: string
    color*: uint32
    backgroundColor*: uint32
    eventsRegistered*: bool

proc newTextInputImpl*(): TextInputImpl =
  new result
  result.initTextBase()
  result.tf = newTextField()
  let self = result
  result.tf.notify(
    proc(text: string) {.gcsafe.} =
      if self.text != text:
        self.text = text
        if self.inputData.onChangedCallback != nil:
          self.inputData.onChangedCallback()
    ,
    proc(p: CaretInfo) {.gcsafe.} =
      self.inputData.hscrollPos = self.tf.scrollLeft
      self.inputData.vscrollPos = self.tf.scrollTop.float
      if self.inputData.onScrollCallback != nil:
        self.inputData.onScrollCallback()
  )

method focus*(self: TextInputImpl) =
  if self.parentComponent != nil:
    self.tf.id = self.parentComponent.idInternal & "_tf"

  if not self.eventsRegistered:
    self.eventsRegistered = true
    # self.parentComponent.registerEvent("hidden", proc(e: UIEvent) = self.blur())

  # self.tf.focus()

method blur*(self: TextInputImpl) =
  # self.tf.blur()
  discard

method validateData*(self: TextInputImpl) =
  if self.text != nil:
    self.tf.text = self.text

  self.tf.scrollLeft = self.inputData.hscrollPos
  self.tf.scrollTop = self.inputData.vscrollPos.int

method validateStyle*(self: TextInputImpl): bool =
  var measureTextRequired = false
  if self.textStyle != nil:
    self.tf.multiline = self.displayData.multiline
    self.tf.wordWrap = self.displayData.wordWrap
    self.tf.password = self.inputData.password

    if self.textStyle.textAlign.isSome:
      self.textAlign = self.textStyle.textAlign.get()

    if self.textStyle.fontSize.isSome and self.fontSize != self.textStyle.fontSize.get():
      self.fontSize = self.textStyle.fontSize.get()
      self.tf.fontSize = self.fontSize.int
      measureTextRequired = true

    if self.fontInfo != nil and self.fontName != self.textStyle.fontName.get():
      self.fontName = self.textStyle.fontName.get()
      self.font = self.fontInfo.data
      self.tf.font = self.font
      measureTextRequired = true

    if self.textStyle.color.isSome:
      let c = self.textStyle.color.get()
      self.tf.textColor = c

    if self.textStyle.backgroundColor.isSome:
      let c = self.textStyle.backgroundColor.get()
      self.tf.backgroundColor = c

  return measureTextRequired

method validateDisplay*(self: TextInputImpl) =
  if self.width > 0:
    self.tf.width = self.width
  if self.height > 0:
    self.tf.height = self.height

method measureText*(self: TextInputImpl) =
  if self.font == nil:
    return

  if self.text == "" or self.font == nil:
    self.textWidth = 0
    self.textHeight = self.font.size.float + 2
    return

  # Simplified measurement
  self.textWidth = 100.0 # TODO
  self.textHeight = self.font.size.float + 2
