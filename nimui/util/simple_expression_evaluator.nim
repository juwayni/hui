import nimui/util/defines
import std/strutils
import std/tables

type
  SimpleExpressionEvaluator* = object

proc defined*(key: string): bool =
  return defines.getAll().hasKey(key)

proc evalCondition*(condition: string): bool =
  if condition == "": return true

  let trimmed = condition.strip()
  if trimmed.startsWith("defined(") and trimmed.endsWith(")"):
    let key = trimmed[8 .. ^2].strip()
    return defined(key)

  # Basic logic for now
  if trimmed == "true": return true
  if trimmed == "false": return false

  return true # Default to true for unknown conditions to not break layouts
