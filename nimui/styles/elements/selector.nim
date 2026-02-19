import nimui/styles/elements/selector_part
import std/strutils

type
  Selector* = ref object
    parts*: seq[SelectorPart]

proc newSelector*(s: string): Selector =
  new result
  result.parts = @[]
  # Simplified parsing logic
  let parts = s.replace(">", " > ").split(' ')
  for p in parts:
    if p == "": continue
    let sp = newSelectorPart()
    # ... (full parsing)
    result.parts.add(sp)
