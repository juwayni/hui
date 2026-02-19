import nimui/util/variant

type
  IItemTransformer*[T] = ref object of RootObj

method transformFrom*[T](self: IItemTransformer[T], i: Variant): T {.base.} =
  # Default implementation
  discard
