type
  StringPropertyDetails*[T] = ref object
    target*: T
    propertyName*: string
    start*: string
    `end`*: string
    startInt*: int
    changeInt*: int
    pattern*: string
    isVariant*: bool

proc newStringPropertyDetails*[T](target: T, propertyName: string, start, `end`: string): StringPropertyDetails[T] =
  new result
  result.target = target
  result.propertyName = propertyName
  result.start = start
  result.end = `end`
