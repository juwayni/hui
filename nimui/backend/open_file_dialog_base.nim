import nimui/containers/dialogs/dialog_types
import nimui/containers/dialogs/dialog
import nimui/util/variant

type
  OpenFileDialogBase* = ref object of RootObj
    selectedFiles*: seq[SelectedFileInfo]
    callback*: proc(button: DialogButton, files: seq[SelectedFileInfo]) {.gcsafe.}
    onDialogClosed*: proc(event: DialogEvent) {.gcsafe.}
    options*: OpenFileDialogOptions

proc newOpenFileDialogBase*(options: OpenFileDialogOptions = nil, callback: proc(button: DialogButton, files: seq[SelectedFileInfo]) {.gcsafe.} = nil): OpenFileDialogBase =
  new result
  result.options = options
  result.callback = callback
  if result.options == nil:
    result.options = OpenFileDialogOptions()

method validateOptions*(self: OpenFileDialogBase) {.base.} =
  if self.options == nil:
    self.options = OpenFileDialogOptions()

method show*(self: OpenFileDialogBase) {.base.} =
  # Default implementation just calls cancelled since we have no native dialog here
  self.dialogCancelled()

method dialogConfirmed*(self: OpenFileDialogBase, files: seq[SelectedFileInfo]) {.base.} =
  self.selectedFiles = files
  if self.callback != nil:
    self.callback(DialogButton.Ok, self.selectedFiles)
  if self.onDialogClosed != nil:
    let event = newDialogEvent("dialogClosed") # Simplified
    event.button = DialogButton.Ok
    # event.selectedFiles = files
    self.onDialogClosed(event)

method dialogCancelled*(self: OpenFileDialogBase) {.base.} =
  self.selectedFiles = @[]
  if self.callback != nil:
    self.callback(DialogButton.Cancel, self.selectedFiles)
  if self.onDialogClosed != nil:
    let event = newDialogEvent("dialogClosed")
    event.button = DialogButton.Cancel
    self.onDialogClosed(event)
