import nimui/core/types
import nimui/styles/elements/directive
import std/tables

type
  DirectiveHandler* = ref object of RootObj

proc newDirectiveHandler*(): DirectiveHandler =
  new result

method apply*(self: DirectiveHandler, component: Component, directive: Directive) {.base.} =
  discard

var directiveHandlers = initTable[string, proc(): DirectiveHandler {.gcsafe.}]()
var directiveHandlerInstances = initTable[string, DirectiveHandler]()

proc registerDirectiveHandler*(name: string, ctor: proc(): DirectiveHandler {.gcsafe.}) =
  directiveHandlers[name] = ctor

proc hasDirectiveHandler*(name: string): bool =
  return directiveHandlers.hasKey(name)

proc getDirectiveHandler*(name: string): DirectiveHandler =
  if directiveHandlerInstances.hasKey(name):
    return directiveHandlerInstances[name]
  if directiveHandlers.hasKey(name):
    let instance = directiveHandlers[name]()
    directiveHandlerInstances[name] = instance
    return instance
  return nil
