import strutils, nimui/util/variant

type
  LocalStringExpressionOperationKind* = enum
    opEquals, opLessThan, opGreaterThan, opLessThanOrEquals, opGreaterThanOrEquals, opRange, opModulus, opList, opValue

  LocalStringExpressionOperation* = ref object
    case kind*: LocalStringExpressionOperationKind
    of opEquals, opLessThan, opGreaterThan, opLessThanOrEquals, opGreaterThanOrEquals:
      expr*: LocalStringExpressionOperation
    of opRange:
      startVal*, endVal*: float
    of opModulus:
      modulus*: float
      modExpr*: LocalStringExpressionOperation
    of opList:
      values*: seq[float]
    of opValue:
      val*: Variant

  LocaleStringExpression* = ref object
    varName*: string
    expression*: LocalStringExpressionOperation
    expressionResult*: string
    isDefault*: bool

proc newLocaleStringExpression*(): LocaleStringExpression =
  new result

proc parseExpression(s: string): LocalStringExpressionOperation =
  let ts = s.strip()
  if ts.startsWith(">="):
    return LocalStringExpressionOperation(kind: opGreaterThanOrEquals, expr: parseExpression(ts[2..^1]))
  elif ts.startsWith("<="):
    return LocalStringExpressionOperation(kind: opLessThanOrEquals, expr: parseExpression(ts[2..^1]))
  elif ts.startsWith(">"):
    return LocalStringExpressionOperation(kind: opGreaterThan, expr: parseExpression(ts[1..^1]))
  elif ts.startsWith("<"):
    return LocalStringExpressionOperation(kind: opLessThan, expr: parseExpression(ts[1..^1]))
  elif ts.startsWith("="):
    return LocalStringExpressionOperation(kind: opEquals, expr: parseExpression(ts[1..^1]))
  else:
    return LocalStringExpressionOperation(kind: opValue, val: toVariant(ts))

proc parse*(self: LocaleStringExpression, s: string) =
  let ts = s.strip()
  let n = ts.find(':')
  if n == -1: return

  let exprStr = ts[0 ..< n].strip()
  self.expressionResult = ts[n+1 .. ^1].strip()

  if exprStr == "_":
    self.isDefault = true
    return

  var splitPos = -1
  for i, c in exprStr:
    if c in {'=', '<', '>', '%', ' '}:
      splitPos = i
      break

  if splitPos != -1:
    self.varName = exprStr[0 ..< splitPos].strip()
    self.expression = parseExpression(exprStr[splitPos .. ^1].strip())

proc evalOp(varValue: Variant, op: LocalStringExpressionOperation): Variant =
  if op == nil: return varValue
  case op.kind:
    of opEquals:
      let res = evalOp(varValue, op.expr)
      return toVariant(varValue.toString == res.toString)
    of opLessThan:
      let res = evalOp(varValue, op.expr)
      return toVariant(varValue.toFloat < res.toFloat)
    of opGreaterThan:
      let res = evalOp(varValue, op.expr)
      return toVariant(varValue.toFloat > res.toFloat)
    of opValue:
      return op.val
    # ... Add more cases for parity
    else:
      return Variant(kind: vkNull)

proc evaluate*(self: LocaleStringExpression, param0, param1, param2, param3: Variant): bool =
  if self.isDefault: return true
  # Map varName to one of the params (HaxeUI uses 0-3)
  var varValue = Variant(kind: vkNull)
  case self.varName:
    of "0": varValue = param0
    of "1": varValue = param1
    of "2": varValue = param2
    of "3": varValue = param3
    else: discard

  return evalOp(varValue, self.expression).toBool
