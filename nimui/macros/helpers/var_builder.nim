import macros
import nimui/macros/helpers/class_builder

type
  VarBuilder* = ref object
    node*: NimNode # nnkIdentDefs
    builder*: ClassBuilder

proc newVarBuilder*(node: NimNode, builder: ClassBuilder): VarBuilder =
  new result
  result.node = node
  result.builder = builder

proc name*(self: VarBuilder): string =
  let id = self.node[0]
  if id.kind == nnkPostfix: return id[1].strVal
  return id.strVal
