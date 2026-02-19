import macros
import std/strutils
import nimui/util/string_util

proc buildLayoutAliases*(fullPath: string): seq[string] =
  var aliases: seq[string] = @[]
  let parts = fullPath.split('.')
  var name = parts[parts.len - 1]
  name = name.replace("Layout", "").strip()
  if name.len > 0:
    aliases.add(name)
    # ... (logic to generate hyphenated/spaced aliases)
  return aliases

macro buildLayout*(): untyped =
  # Generates cloneLayout and registers aliases
  result = newStmtList()
