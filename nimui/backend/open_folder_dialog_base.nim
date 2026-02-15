import nimui/containers/dialogs/dialog
import nimui/containers/dialogs/dialogs

type
  OpenFolderDialogOptions* = object
    defaultPath*: string
    title*: string
    multiple*: bool
    hiddenFolders*: bool
    canCreateFolder*: bool

  OpenFolderDialogBase* = ref object of RootObj
    selectedFolders*: seq[string]
    callback*: proc(button: DialogButton, folders: seq[string])
    onDialogClosed*: proc(event: DialogEvent)
    options*: OpenFolderDialogOptions

proc newOpenFolderDialogBase*(options: OpenFolderDialogOptions, callback: proc(button: DialogButton, folders: seq[string])): OpenFolderDialogBase =
  result = OpenFolderDialogBase(
    options: options,
    callback: callback
  )

method show*(self: OpenFolderDialogBase) {.base.} =
  discard

method dialogConfirmed*(self: OpenFolderDialogBase, folders: seq[string]) {.base.} =
  self.selectedFolders = folders
  if self.callback != nil:
    self.callback(DialogButtonOk, self.selectedFolders)
  if self.onDialogClosed != nil:
    let event = newDialogEvent(DialogEventClosed)
    event.button = DialogButtonOk
    self.onDialogClosed(event)

method dialogCancelled*(self: OpenFolderDialogBase) {.base.} =
  self.selectedFolders = @[]
  if self.callback != nil:
    self.callback(DialogButtonCancel, self.selectedFolders)
  if self.onDialogClosed != nil:
    let event = newDialogEvent(DialogEventClosed)
    event.button = DialogButtonCancel
    self.onDialogClosed(event)
