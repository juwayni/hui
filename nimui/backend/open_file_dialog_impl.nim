import nimui/backend/open_file_dialog_base
import os_files/dialog as os_dialog
import nimui/containers/dialogs/dialogs
import nimui/containers/dialogs/dialog

type
  OpenFileDialogImpl* = ref object of OpenFileDialogBase

method show*(self: OpenFileDialogImpl) =
  var di: DialogInfo
  di.kind = dkOpenFile
  di.title = self.options.title

  let file = os_dialog.show(di)
  if file != "":
    self.dialogConfirmed(@[SelectedFileInfo(
      name: file,
      fullPath: file
    )])
  else:
    self.dialogCancelled()
