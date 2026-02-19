import std/macros

macro build*(resourcePath: static string, params: untyped = nil): untyped =
  # Call ComponentMacros equivalent
  result = nnkStmtList.newTree()

macro fromFile*(filePath: static string, params: untyped = nil): untyped =
  result = nnkStmtList.newTree()

macro fromString*(source: static string, params: untyped = nil): untyped =
  result = nnkStmtList.newTree()
