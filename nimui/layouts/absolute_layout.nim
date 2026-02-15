import nimui/layouts/default_layout

type
  AbsoluteLayout* = ref object of DefaultLayout

proc newAbsoluteLayout*(): AbsoluteLayout =
  new result

method repositionChildren*(self: AbsoluteLayout) =
  # Absolute layout does not reposition children
  discard
