import std/strutils

type
  SelectorPart* = ref object
    parent*: SelectorPart
    pseudoClass*: string
    className*: string
    id*: string
    nodeName*: string
    direct*: bool

proc newSelectorPart*(): SelectorPart =
  new result

proc classNameParts*(self: SelectorPart): seq[string] =
  if self.className == "": return @[]
  return self.className.split('.')
