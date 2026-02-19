import nimui/util/variant

type
  FileDialogExtensionInfo* = ref object
    extension*: string
    label*: string

  FileInfo* = ref object
    name*: string
    text*: string
    bytes*: seq[byte]
    isBinary*: bool

  SelectedFileInfo* = ref object of FileInfo
    fullPath*: string

  OpenFileDialogOptions* = ref object
    readContents*: bool
    readAsBinary*: bool
    multiple*: bool
    extensions*: seq[FileDialogExtensionInfo]
    title*: string

  OpenFolderDialogOptions* = ref object
    defaultPath*: string
    title*: string
    multiple*: bool
    hiddenFolders*: bool
    canCreateFolder*: bool

  SaveFileDialogOptions* = ref object
    writeAsBinary*: bool
    extensions*: seq[FileDialogExtensionInfo]
    title*: string
