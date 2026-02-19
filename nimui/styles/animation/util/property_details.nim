type
  PropertyDetails*[T] = ref object
    target*: T
    propertyName*: string
    start*: float
    change*: float
    lastValue*: float

proc newPropertyDetails*[T](target: T, propertyName: string, start: float, change: float): PropertyDetails[T] =
  new result
  result.target = target
  result.propertyName = propertyName
  result.start = start
  result.change = change
