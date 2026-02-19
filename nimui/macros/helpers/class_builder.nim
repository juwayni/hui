import macros
import nimui/macros/helpers/code_builder
import nimui/macros/helpers/code_pos

type
  ClassBuilder* = ref object
    typeNode*: NimNode # nnkTypeDef
    procs*: seq[NimNode] # nnkProcDef or nnkMethodDef

proc newClassBuilder*(typeNode: NimNode): ClassBuilder =
  new result
  result.typeNode = typeNode
  result.procs = @[]

proc findRecList(node: NimNode): NimNode =
  # Find the nnkRecList inside nnkTypeDef -> nnkObjectTy
  if node.kind == nnkTypeDef:
    let objTy = node[2]
    if objTy.kind == nnkRefTy:
      let actualObj = objTy[0]
      if actualObj.kind == nnkObjectTy:
        return actualObj[2]
    elif objTy.kind == nnkObjectTy:
      return objTy[2]
  return nil

proc hasField*(self: ClassBuilder, name: string): bool =
  let recList = findRecList(self.typeNode)
  if recList != nil:
    for identDefs in recList:
      for i in 0 ..< identDefs.len - 2:
        if identDefs[i].kind == nnkPostfix:
          if identDefs[i][1].strVal == name: return true
        elif identDefs[i].strVal == name: return true
  return false

proc addVar*(self: ClassBuilder, name: string, typ: NimNode, exported: bool = true) =
  let recList = findRecList(self.typeNode)
  if recList != nil:
    let fieldName = if exported: postfix(ident(name), "*") else: ident(name)
    recList.add(newIdentDefs(fieldName, typ))

proc findFunction*(self: ClassBuilder, name: string): NimNode =
  # Search in self.procs or maybe in the module?
  # This is harder in Nim because procs are not inside the type definition.
  for p in self.procs:
    if p.name.strVal == name: return p
  return nil

proc addFunction*(self: ClassBuilder, name: string, body: NimNode, args: seq[NimNode] = @[], retType: NimNode = nil): NimNode =
  # Create a method or proc for the class
  # Need to know the class name for the 'self' parameter
  let className = self.typeNode[0]
  var params = @[if retType == nil: ident("void") else: retType]
  params.add(newIdentDefs(ident("self"), className))
  for arg in args: params.add(arg)

  result = newMethod(postfix(ident(name), "*"), params, body)
  self.procs.add(result)
