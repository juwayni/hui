type
  IActionInputSource* = ref object of RootObj

method start*(self: IActionInputSource) {.base.} =
  discard
