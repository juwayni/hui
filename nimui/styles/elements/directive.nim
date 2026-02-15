import nimui/styles/value

type
  Directive* = ref object
    directive*: string
    value*: Value

proc newDirective*(directive: string, value: Value): Directive =
  Directive(directive: directive, value: value)
