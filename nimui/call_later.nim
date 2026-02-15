import nimui/backend/call_later_impl

type
  CallLater* = ref object of CallLaterImpl

proc newCallLater*(fn: proc() {.gcsafe.}): CallLater =
  newCallLaterImpl(fn)
  return nil
