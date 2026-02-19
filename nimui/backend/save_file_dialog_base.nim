import nimui/containers/dialogs/dialog_types
import nimui/containers/dialogs/dialog
import nimui/util/variant

type
  SaveFileDialogBase* = ref object of RootObj
    saveResult*: bool
    fullPath*: string
    callback*: proc(button: DialogButton, result: bool, path: string) {.gcsafe.}
    onDialogClosed*: proc(event: DialogEvent) {.gcsafe.}
    fileInfo*: FileInfo
    selectedFileInfo*: SelectedFileInfo
    options*: SaveFileDialogOptions

proc newSaveFileDialogBase*(options: SaveFileDialogOptions = nil, callback: proc(button: DialogButton, result: bool, path: string) {.gcsafe.} = nil): SaveFileDialogBase =
  new result
  result.options = options
  result.callback = callback
  if result.options == nil:
    result.options = SaveFileDialogOptions()

method validateOptions*(self: SaveFileDialogBase) {.base.} =
  if self.options == nil:
    self.options = SaveFileDialogOptions()

method show*(self: SaveFileDialogBase) {.base.} =
  self.dialogCancelled()

method dialogConfirmed*(self: SaveFileDialogBase, selectedFileInfo: SelectedFileInfo = nil) {.base.} =
  self.saveResult = true
  if selectedFileInfo != nil:
    self.selectedFileInfo = selectedFileInfo
    self.fileInfo = selectedFileInfo
    self.fullPath = selectedFileInfo.fullPath

  if self.callback != nil:
    self.callback(DialogButton.Ok, self.saveResult, self.fullPath)

  if self.onDialogClosed != nil:
    let event = newDialogEvent("dialogClosed")
    event.button = DialogButton.Ok
    self.onDialogClosed(event)

method dialogCancelled*(self: SaveFileDialogBase) {.base.} =
  self.saveResult = false
  self.selectedFileInfo = nil
  self.fileInfo = nil
  self.fullPath = ""

  if self.callback != nil:
    self.callback(DialogButton.Cancel, self.saveResult, "")

  if self.onDialogClosed != nil:
    let event = newDialogEvent("dialogClosed")
    event.button = DialogButton.Cancel
    self.onDialogClosed(event)
