import macros
import nimui/macros/helpers/code_pos

type
  CodeBuilder* = ref object
    node*: NimNode

proc newCodeBuilder*(node: NimNode = nil): CodeBuilder =
  new result
  if node == nil:
    result.node = newStmtList()
  else:
    result.node = node

proc findSuper(node: NimNode): int =
  # In Nim, super calls might look like procCall super(...) or similar
  # or just call to another proc.
  # This is tricky in Nim because there is no single 'super' keyword.
  # For now return -1.
  return -1

proc add*(self: CodeBuilder, e: NimNode, where: CodePos = start()) =
  case where.kind:
  of cpStart:
    self.node.insert(0, e)
  of cpEnd:
    self.node.add(e)
  of cpAfterSuper:
    let s = findSuper(self.node)
    if s == -1:
      self.node.add(e)
    else:
      self.node.insert(s + 1, e)
  of cpPos:
    self.node.insert(where.pos, e)

proc addToStart*(self: CodeBuilder, e: NimNode) =
  self.add(e, start())

proc expr*(self: CodeBuilder): NimNode =
  return self.node
