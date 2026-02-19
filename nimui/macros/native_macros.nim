import std/macros

macro processNative*(): untyped =
  result = nnkStmtList.newTree()
  # Placeholder for native config processing
