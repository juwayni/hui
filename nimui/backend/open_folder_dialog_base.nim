import nimui/containers/dialogs/dialog_types
import nimui/containers/dialogs/dialog
import nimui/util/variant

type
  OpenFolderDialogBase* = ref object of RootObj
    selectedFolders*: seq[string]
    callback*: proc(button: DialogButton, folders: seq[string]) {.gcsafe.}
    onDialogClosed*: proc(event: DialogEvent) {.gcsafe.}
    options*: OpenFolderDialogOptions

proc newOpenFolderDialogBase*(options: OpenFolderDialogOptions = nil, callback: proc(button: DialogButton, folders: seq[string]) {.gcsafe.} = nil): OpenFolderDialogBase =
  new result
  result.options = options
  result.callback = callback
  if result.options == nil:
    result.options = OpenFolderDialogOptions()

method validateOptions*(self: OpenFolderDialogBase) {.base.} =
  if self.options == nil:
    self.options = OpenFolderDialogOptions()

method show*(self: OpenFolderDialogBase) {.base.} =
  self.dialogCancelled()

method dialogConfirmed*(self: OpenFolderDialogBase, folders: seq[string]) {.base.} =
  self.selectedFolders = folders
  if self.callback != nil:
    self.callback(DialogButton.Ok, self.selectedFolders)
  if self.onDialogClosed != nil:
    let event = newDialogEvent("dialogClosed")
    event.button = DialogButton.Ok
    self.onDialogClosed(event)

method dialogCancelled*(self: OpenFolderDialogBase) {.base.} =
  self.selectedFolders = @[]
  if self.callback != nil:
    self.callback(DialogButton.Cancel, self.selectedFolders)
  if self.onDialogClosed != nil:
    let event = newDialogEvent("dialogClosed")
    event.button = DialogButton.Cancel
    self.onDialogClosed(event)
