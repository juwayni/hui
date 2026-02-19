import nimui/core/types

type
  FocusApplicator* = ref object of RootObj
    enabledInternal: bool

proc initFocusApplicator*(self: FocusApplicator) =
  self.enabledInternal = true

proc newFocusApplicator*(): FocusApplicator =
  new result
  result.initFocusApplicator()

method apply*(self: FocusApplicator, target: Component) {.base.} =
  discard

method unapply*(self: FocusApplicator, target: Component) {.base.} =
  discard

method enabled*(self: FocusApplicator): bool {.base.} =
  return self.enabledInternal

method `enabled=`*(self: FocusApplicator, value: bool) {.base.} =
  self.enabledInternal = value
