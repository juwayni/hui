import ./locale_string_expression
import nimui/util/variant
import strutils

type
  LocaleStringExpressionBlock* = ref object
    expressions*: seq[LocaleStringExpression]

proc newLocaleStringExpressionBlock*(): LocaleStringExpressionBlock =
  new result
  result.expressions = @[]

proc parse*(self: LocaleStringExpressionBlock, s: string) =
  self.expressions = @[]
  for line in s.strip().split('\n'):
    let expr = newLocaleStringExpression()
    expr.parse(line)
    self.expressions.add(expr)

proc evaluate*(self: LocaleStringExpressionBlock, param0, param1, param2, param3: Variant): string =
  for expr in self.expressions:
    if expr.isDefault: continue
    if expr.evaluate(param0, param1, param2, param3):
      return expr.expressionResult

  for expr in self.expressions:
    if expr.isDefault:
      return expr.expressionResult

  return ""
