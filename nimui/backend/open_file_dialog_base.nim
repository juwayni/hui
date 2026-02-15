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
    callback*: proc(button: DialogButton, selectedFiles: seq[SelectedFileInfo])
    onDialogClosed*: proc(event: DialogEvent)
    options*: OpenFileDialogOptions

proc newOpenFileDialogBase*(options: OpenFileDialogOptions, callback: proc(button: DialogButton, selectedFiles: seq[SelectedFileInfo])): OpenFileDialogBase =
  OpenFileDialogBase(options: options, callback: callback)

proc validateOptions*(self: OpenFileDialogBase) =
  # In Nim, objects have default values, but we can explicitly set them if they weren't initialized
  # or use this to ensure consistency.
  discard # defaults are already false/empty for these types in Nim

method show*(self: OpenFileDialogBase) {.base.} =
  messageBox("OpenFileDialog has no implementation on this backend", "Open File", mtError)

proc dialogConfirmed*(self: OpenFileDialogBase, files: seq[SelectedFileInfo]) =
  self.selectedFiles = files
  if self.callback != nil:
    self.callback(DialogButtonOk, self.selectedFiles)
  if self.onDialogClosed != nil:
    let event = newDialogEvent(DialogEventClosed)
    event.button = DialogButtonOk
    self.onDialogClosed(event)

proc dialogCancelled*(self: OpenFileDialogBase) =
  self.selectedFiles = @[]
  if self.callback != nil:
    self.callback(DialogButtonCancel, self.selectedFiles)
  if self.onDialogClosed != nil:
    let event = newDialogEvent(DialogEventClosed)
    event.button = DialogButtonCancel
    self.onDialogClosed(event)
