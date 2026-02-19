type
  CodePosKind* = enum
    cpStart,
    cpEnd,
    cpAfterSuper,
    cpPos

  CodePos* = object
    case kind*: CodePosKind
    of cpPos:
      pos*: int
    else: discard

proc start*(): CodePos = CodePos(kind: cpStart)
proc end*(): CodePos = CodePos(kind: cpEnd)
proc afterSuper*(): CodePos = CodePos(kind: cpAfterSuper)
proc pos*(p: int): CodePos = CodePos(kind: cpPos, pos: p)
