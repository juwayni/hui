import std/tables

type
  ThemeEntry* = object
    resourceId*: string
    priority*: float
    styleData*: string

  ThemeImageEntry* = object
    id*: string
    resourceId*: string
    priority*: float

  Theme* = ref object
    parent*: string
    styles*: seq[ThemeEntry]
    images*: seq[ThemeImageEntry]
    vars*: Table[string, string]

proc newTheme*(): Theme =
  new result
  result.styles = @[]
  result.images = @[]
  result.vars = initTable[string, string]()
