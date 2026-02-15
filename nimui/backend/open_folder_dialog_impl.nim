import nimui/backend/open_folder_dialog_base
import os_files/dialog as os_dialog
import nimui/containers/dialogs/dialogs
import nimui/containers/dialogs/dialog

type
  OpenFolderDialogImpl* = ref object of OpenFolderDialogBase

method show*(self: OpenFolderDialogImpl) =
  var di: DialogInfo
  di.kind = dkSelectFolder
  di.title = self.options.title
  di.folder = self.options.defaultPath

  let folder = os_dialog.show(di)
  if folder != "":
    self.dialogConfirmed(@[folder])
  else:
    self.dialogCancelled()
