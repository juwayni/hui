type
  FileDialogExtensionInfo* = object
    extension*: string
    label*: string

  FileInfo* = ref object of RootObj
    name*: string
    text*: string
    bytes*: seq[byte]
    isBinary*: bool

  SelectedFileInfo* = ref object of FileInfo
    fullPath*: string

  MessageBoxType* = enum
    TYPE_INFO, TYPE_QUESTION, TYPE_WARNING, TYPE_ERROR, TYPE_YESNO
