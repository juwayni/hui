type
  ComponentStyleInfo* = ref object
    scope*: string
    style*: string

proc newComponentStyleInfo*(style: string, scope: string = "global"): ComponentStyleInfo =
  ComponentStyleInfo(style: style, scope: scope)
