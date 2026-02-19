type
  IValidatingBehaviour* = ref object of RootObj

method validate*(self: IValidatingBehaviour) {.base, gcsafe.} =
  discard
