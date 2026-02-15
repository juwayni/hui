type
  CallLaterImpl* = ref object of RootObj

var callLaterQueue*: seq[proc() {.closure.}] = @[]

proc newCallLaterImpl*(fn: proc() {.closure.}): CallLaterImpl =
  callLaterQueue.add(fn)
  return CallLaterImpl()
