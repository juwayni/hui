import macros, nimui/util/variant, nimui/core/types

macro generateSetProperty*(T: typedesc) =
  let typeName = T.getTypeImpl()[1].strVal
  let fields = T.getTypeImpl()[2][2] # Simplified field access

  var cases = nnkCaseStmt.newTree(ident("name"))
  for field in fields:
    let fieldName = field[0].strVal
    cases.add nnkOfBranch.newTree(
      newLit(fieldName),
      nnkStmtList.newTree(
        nnkAsgn.newTree(
          nnkDotExpr.newTree(ident("self"), ident(fieldName)),
          # Need to convert Variant to field type
          ident("value")
        )
      )
    )
  cases.add nnkElse.newTree(nnkDiscardStmt.newTree())

  result = nnkMethodDef.newTree(
    ident("setProperty"),
    nnkEmpty.newTree(),
    nnkEmpty.newTree(),
    nnkFormalParams.newTree(
      nnkEmpty.newTree(),
      nnkIdentDefs.newTree(ident("self"), T, nnkEmpty.newTree()),
      nnkIdentDefs.newTree(ident("name"), ident("string"), nnkEmpty.newTree()),
      nnkIdentDefs.newTree(ident("value"), ident("Variant"), nnkEmpty.newTree())
    ),
    nnkEmpty.newTree(),
    nnkEmpty.newTree(),
    nnkStmtList.newTree(cases)
  )
