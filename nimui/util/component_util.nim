import nimui/core/types
import std/strutils

type
  ComponentUtil* = object

proc getDepth*(target: Component): int =
  var count = 0
  var t = target
  while t.parentComponent != nil:
    t = t.parentComponent
    count += 1
  return count

proc walkComponentTree*(fromComp: Component, cb: proc(depth: int, c: Component) {.gcsafe.}) =
  proc recurse(depth: int, c: Component) =
    cb(depth, c)
    for child in c.childComponents:
      recurse(depth + 1, child)
  recurse(0, fromComp)
