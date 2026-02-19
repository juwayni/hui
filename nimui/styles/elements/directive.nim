import ../value

type
  Directive* = ref object
    directive*: string
    value*: Value
    defective*: bool

proc newDirective*(directive: string, value: Value, defective: bool = false): Directive =
  Directive(directive: directive, value: value, defective: defective)
