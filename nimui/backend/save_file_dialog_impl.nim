import nimui/backend/save_file_dialog_base
import os_files/dialog as os_dialog
import nimui/containers/dialogs/dialogs
import nimui/containers/dialogs/dialog

type
  SaveFileDialogImpl* = ref object of SaveFileDialogBase

method show*(self: SaveFileDialogImpl) =
  var di: DialogInfo
  di.kind = dkSaveFile
  di.title = self.options.title
  if self.fileInfo != nil:
    di.folder = self.fileInfo.name

  let file = os_dialog.show(di)
  if file != "":
    self.dialogConfirmed(SelectedFileInfo(
      name: file,
      fullPath: file
    ))
  else:
    self.dialogCancelled()
