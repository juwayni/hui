import macros
import nimui/macros/helpers/class_builder

type
  FieldBuilder* = ref object
    node*: NimNode # nnkIdentDefs
    builder*: ClassBuilder

proc newFieldBuilder*(node: NimNode, builder: ClassBuilder): FieldBuilder =
  new result
  result.node = node
  result.builder = builder

proc name*(self: FieldBuilder): string =
  # node is nnkIdentDefs, [0] is ident or postfix
  let id = self.node[0]
  if id.kind == nnkPostfix: return id[1].strVal
  return id.strVal

proc `name=`*(self: FieldBuilder, value: string) =
  let id = self.node[0]
  if id.kind == nnkPostfix: id[1] = ident(value)
  else: self.node[0] = ident(value)

proc typ*(self: FieldBuilder): NimNode =
  return self.node[self.node.len - 2]

proc addPragma*(self: FieldBuilder, name: string, value: NimNode = nil) =
  # Pragmas in Nim are complex to add to fields.
  # Usually done with {. .}
  discard
