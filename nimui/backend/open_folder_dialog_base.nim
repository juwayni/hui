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
    callback*: proc(button: DialogButton, selectedFolders: seq[string])
    onDialogClosed*: proc(event: DialogEvent)
    options*: OpenFolderDialogOptions

proc newOpenFolderDialogBase*(options: OpenFolderDialogOptions, callback: proc(button: DialogButton, selectedFolders: seq[string])): OpenFolderDialogBase =
  OpenFolderDialogBase(options: options, callback: callback)

proc validateOptions*(self: OpenFolderDialogBase) =
  discard

method show*(self: OpenFolderDialogBase) {.base.} =
  messageBox("OpenFolderDialog has no implementation on this backend", "Open Folder", mtError)

proc dialogConfirmed*(self: OpenFolderDialogBase, folders: seq[string]) =
  self.selectedFolders = folders
  if self.callback != nil:
    self.callback(DialogButtonOk, self.selectedFolders)
  if self.onDialogClosed != nil:
    let event = newDialogEvent(DialogEventClosed)
    event.button = DialogButtonOk
    self.onDialogClosed(event)

proc dialogCancelled*(self: OpenFolderDialogBase) =
  self.selectedFolders = @[]
  if self.callback != nil:
    self.callback(DialogButtonCancel, self.selectedFolders)
  if self.onDialogClosed != nil:
    let event = newDialogEvent(DialogEventClosed)
    event.button = DialogButtonCancel
    self.onDialogClosed(event)
