import nimui/backend/open_file_dialog_base
import nimui/containers/dialogs/dialog_types
import nimui/containers/dialogs/dialog

type
  OpenFileDialogImpl* = ref object of OpenFileDialogBase

method show*(self: OpenFileDialogImpl) =
  # Actual native dialog would go here
  # For now, just cancel
  self.dialogCancelled()
