import nimui/core/types

type
  FocusManagerBase* = ref object of RootObj

method applyFocus*(self: FocusManagerBase, c: Component) {.base, gcsafe.} = discard
method unapplyFocus*(self: FocusManagerBase, c: Component) {.base, gcsafe.} = discard
