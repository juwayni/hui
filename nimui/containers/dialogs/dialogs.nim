import nimui/containers/dialogs/dialog

type
  FileDialogExtensionInfo* = object
    extension*: string
    label*: string

  FileInfo* = object
    name*: string
    text*: string
    bytes*: seq[byte]
    isBinary*: bool

  SelectedFileInfo* = object
    name*: string
    text*: string
    bytes*: seq[byte]
    isBinary*: bool
    fullPath*: string

type
  MessageBoxType* = enum
    mtInfo, mtQuestion, mtWarning, mtError, mtYesNo

proc messageBox*(message: string, title: string = "", kind: MessageBoxType = mtInfo) =
  # Minimal implementation
  discard

proc openFile*(callback: proc(button: DialogButton, selectedFiles: seq[SelectedFileInfo]), options: pointer = nil) =
  # Minimal implementation
  discard
