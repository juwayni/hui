type
  IValidating* = ref object of RootObj

method depth*(self: IValidating): int {.base.} = discard
method `depth=`*(self: IValidating, value: int) {.base.} = discard

method id*(self: IValidating): string {.base.} = discard
method `id=`*(self: IValidating, value: string) {.base.} = discard

method validateComponent*(self: IValidating, nextFrame: bool = true) {.base.} = discard
method updateComponentDisplay*(self: IValidating) {.base.} = discard

method isComponentOffscreen*(self: IValidating): bool {.base.} = return false
