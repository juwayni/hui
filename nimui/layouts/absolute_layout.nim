import nimui/layouts/default_layout

type
  AbsoluteLayout* = ref object of DefaultLayout

proc newAbsoluteLayout*(): AbsoluteLayout =
  new result

method repositionChildren*(self: AbsoluteLayout) =
  # Absolute layout doesn't reposition children (they keep their own left/top)
  discard
