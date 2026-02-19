import nimui/backend/save_file_dialog_base

type
  SaveFileDialogImpl* = ref object of SaveFileDialogBase

method show*(self: SaveFileDialogImpl) =
  self.dialogCancelled()
