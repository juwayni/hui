import std/strutils

type
  ExpressionUtil* = object

proc stringToLanguageExpression*(s: string, localeManager: string = "nimui/locale/locale_manager"): string =
  # Porting logic to convert {{id}} to localeManager.lookupString('id')
  var res = ""
  var n1 = s.find("{{")
  var lastPos = 0
  while n1 != -1:
    let before = s.substr(lastPos, n1 - 1)
    if before.len > 0:
      if res.len > 0: res &= " + "
      res &= "'" & before & "'"

    let n2 = s.find("}}", n1)
    let code = s.substr(n1 + 2, n2 - 1)
    if res.len > 0: res &= " + "
    res &= "instance().lookupString('" & code & "')"

    lastPos = n2 + 2
    n1 = s.find("{{", lastPos)

  if lastPos < s.len:
    let after = s.substr(lastPos)
    if res.len > 0: res &= " + "
    res &= "'" & after & "'"

  return res
