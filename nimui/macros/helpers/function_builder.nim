import macros
import nimui/macros/helpers/code_builder
import nimui/macros/helpers/code_pos

type
  FunctionBuilder* = ref object
    node*: NimNode # nnkProcDef or nnkMethodDef

proc newFunctionBuilder*(node: NimNode): FunctionBuilder =
  new result
  result.node = node

proc name*(self: FunctionBuilder): string =
  let id = self.node[0]
  if id.kind == nnkPostfix: return id[1].strVal
  return id.strVal

proc add*(self: FunctionBuilder, e: NimNode, where: CodePos = start()) =
  let body = self.node.body
  var cb = newCodeBuilder(body)
  cb.add(e, where)
  self.node.body = cb.expr()
