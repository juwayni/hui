import nimui/containers/dialogs/dialog
import nimui/containers/dialogs/dialogs

type
  OpenFileDialogOptions* = object
    readContents*: bool
    readAsBinary*: bool
    multiple*: bool
    extensions*: seq[FileDialogExtensionInfo]
    title*: string

  OpenFileDialogBase* = ref object of RootObj
    selectedFiles*: seq[SelectedFileInfo]
    callback*: proc(button: DialogButton, files: seq[SelectedFileInfo])
    onDialogClosed*: proc(event: DialogEvent)
    options*: OpenFileDialogOptions

proc newOpenFileDialogBase*(options: OpenFileDialogOptions, callback: proc(button: DialogButton, files: seq[SelectedFileInfo])): OpenFileDialogBase =
  result = OpenFileDialogBase(
    options: options,
    callback: callback
  )

method show*(self: OpenFileDialogBase) {.base.} =
  discard

method dialogConfirmed*(self: OpenFileDialogBase, files: seq[SelectedFileInfo]) {.base.} =
  self.selectedFiles = files
  if self.callback != nil:
    self.callback(DialogButtonOk, self.selectedFiles)
  if self.onDialogClosed != nil:
    let event = newDialogEvent(DialogEventClosed)
    event.button = DialogButtonOk
    self.onDialogClosed(event)

method dialogCancelled*(self: OpenFileDialogBase) {.base.} =
  self.selectedFiles = @[]
  if self.callback != nil:
    self.callback(DialogButtonCancel, self.selectedFiles)
  if self.onDialogClosed != nil:
    let event = newDialogEvent(DialogEventClosed)
    event.button = DialogButtonCancel
    self.onDialogClosed(event)
