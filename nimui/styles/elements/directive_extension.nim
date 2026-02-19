import ./directive

type
  DirectiveExtension* = ref object of Directive

import ../value

proc newDirectiveExtension*(directive: string): DirectiveExtension =
  DirectiveExtension(directive: directive, value: Value(kind: vkNone), defective: false)
