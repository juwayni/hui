import strutils, re

proc styleProperty2ComponentProperty*(property: string): string =
  var result = ""
  var upperNext = false
  for c in property:
    if c == '-':
      upperNext = true
    else:
      if upperNext:
        result.add(c.toUpperAscii())
        upperNext = false
      else:
        result.add(c)
  return result

proc componentProperty2StyleProperty*(property: string): string =
  var result = ""
  for c in property:
    if c.isUpperAscii():
      result.add('-')
      result.add(c.toLowerAscii())
    else:
      result.add(c)
  return result
