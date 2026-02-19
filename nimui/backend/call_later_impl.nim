import std/asyncdispatch

type
  CallLaterImpl* = ref object

proc newCallLaterImpl*(fn: proc() {.gcsafe.}) =
  callSoon(fn)
