import nimui/util/color

type
  ColorPropertyDetails*[T] = ref object
    target*: T
    propertyName*: string
    start*: Color
    changeR*: int
    changeG*: int
    changeB*: int
    changeA*: int

proc newColorPropertyDetails*[T](target: T, propertyName: string, start: Color, changeR, changeG, changeB, changeA: int): ColorPropertyDetails[T] =
  new result
  result.target = target
  result.propertyName = propertyName
  result.start = start
  result.changeR = changeR
  result.changeG = changeG
  result.changeB = changeB
  result.changeA = changeA
