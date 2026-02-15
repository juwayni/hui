type
  EventBase* = ref object of RootObj

method cancel*(self: EventBase) {.base.} =
  discard

method postClone*(self: EventBase, event: RootRef) {.base.} =
  discard
