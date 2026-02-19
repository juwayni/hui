type
  IFocusable* = concept x
    x.focus is bool
    x.allowFocus is bool
    x.autoFocus is bool
    x.disabled is bool
