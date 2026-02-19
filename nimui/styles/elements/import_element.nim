type
  ImportElement* = ref object
    url*: string

proc newImportElement*(url: string): ImportElement =
  new result
  result.url = url
