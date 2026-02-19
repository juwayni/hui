import nimui/core/types

type
  FocusManagerImpl* = ref object of RootObj

proc initFocusManagerImpl*(self: FocusManagerImpl) =
  discard

method applyFocus*(self: FocusManagerImpl, c: Component) {.base.} =
  discard

method unapplyFocus*(self: FocusManagerImpl, c: Component) {.base.} =
  discard
