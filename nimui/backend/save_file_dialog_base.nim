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
    callback*: proc(button: DialogButton, success: bool, path: string)
    onDialogClosed*: proc(event: DialogEvent)
    fileInfo*: FileInfo
    selectedFileInfo*: SelectedFileInfo
    options*: SaveFileDialogOptions

proc newSaveFileDialogBase*(options: SaveFileDialogOptions, callback: proc(button: DialogButton, success: bool, path: string)): SaveFileDialogBase =
  SaveFileDialogBase(options: options, callback: callback)

proc validateOptions*(self: SaveFileDialogBase) =
  discard

method show*(self: SaveFileDialogBase) {.base.} =
  messageBox("SaveFileDialog has no implementation on this backend", "Save File", mtError)

proc dialogConfirmed*(self: SaveFileDialogBase, selectedFileInfo: SelectedFileInfo) =
  self.saveResult = true
  self.selectedFileInfo = selectedFileInfo
  self.fileInfo = FileInfo(name: selectedFileInfo.name, text: selectedFileInfo.text, bytes: selectedFileInfo.bytes, isBinary: selectedFileInfo.isBinary)
  self.fullPath = selectedFileInfo.fullPath

  if self.callback != nil:
    self.callback(DialogButtonOk, self.saveResult, self.fullPath)
  if self.onDialogClosed != nil:
    let event = newDialogEvent(DialogEventClosed)
    event.button = DialogButtonOk
    self.onDialogClosed(event)

proc dialogCancelled*(self: SaveFileDialogBase) =
  self.saveResult = false
  if self.callback != nil:
    self.callback(DialogButtonCancel, self.saveResult, "")
  if self.onDialogClosed != nil:
    let event = newDialogEvent(DialogEventClosed)
    event.button = DialogButtonCancel
    self.onDialogClosed(event)
