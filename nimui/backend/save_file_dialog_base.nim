import nimui/containers/dialogs/dialog
import nimui/containers/dialogs/dialogs

type
  SaveFileDialogOptions* = object
    writeAsBinary*: bool
    extensions*: seq[FileDialogExtensionInfo]
    title*: string

  SaveFileDialogBase* = ref object of RootObj
    saveResult*: bool
    fullPath*: string
    callback*: proc(button: DialogButton, result: bool, path: string)
    onDialogClosed*: proc(event: DialogEvent)
    fileInfo*: FileInfo
    selectedFileInfo*: SelectedFileInfo
    options*: SaveFileDialogOptions

proc newSaveFileDialogBase*(options: SaveFileDialogOptions, callback: proc(button: DialogButton, result: bool, path: string)): SaveFileDialogBase =
  result = SaveFileDialogBase(
    options: options,
    callback: callback
  )

method show*(self: SaveFileDialogBase) {.base.} =
  discard

method dialogConfirmed*(self: SaveFileDialogBase, selectedFileInfo: SelectedFileInfo = nil) {.base.} =
  self.saveResult = true
  if selectedFileInfo != nil:
    self.selectedFileInfo = selectedFileInfo
    self.fileInfo = selectedFileInfo
    self.fullPath = selectedFileInfo.fullPath

  if self.callback != nil:
    self.callback(DialogButtonOk, self.saveResult, self.fullPath)

  if self.onDialogClosed != nil:
    let event = newDialogEvent(DialogEventClosed)
    event.button = DialogButtonOk
    self.onDialogClosed(event)

method dialogCancelled*(self: SaveFileDialogBase) {.base.} =
  self.saveResult = false
  self.selectedFileInfo = nil
  self.fileInfo = nil
  self.fullPath = ""

  if self.callback != nil:
    self.callback(DialogButtonCancel, self.saveResult, "")

  if self.onDialogClosed != nil:
    let event = newDialogEvent(DialogEventClosed)
    event.button = DialogButtonCancel
    self.onDialogClosed(event)
