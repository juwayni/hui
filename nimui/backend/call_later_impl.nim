import asyncdispatch

type
  CallLaterImpl* = ref object of RootObj

proc newCallLaterImpl*(fn: proc() {.gcsafe.}) =
  # Execute after a very short delay
  callSoon(fn)
