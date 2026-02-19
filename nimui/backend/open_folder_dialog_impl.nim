import nimui/backend/open_folder_dialog_base

type
  OpenFolderDialogImpl* = ref object of OpenFolderDialogBase

method show*(self: OpenFolderDialogImpl) =
  self.dialogCancelled()
