import tables

let fieldMap = {
  "group": "componentGroup",
  "contentLayout": "contentLayoutName"
}.toTable

proc mapField*(name: string): string =
  if fieldMap.hasKey(name):
    return fieldMap[name]
  return name
