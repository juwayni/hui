import ../../../util/color

type
  ColorPropertyDetails*[T] = ref object
    target*: T
    propertyName*: string
    start*: Color
    changeR*, changeG*, changeB*, changeA*: int

proc newColorPropertyDetails*[T](target: T, propertyName: string, start: Color, changeR, changeG, changeB, changeA: int): ColorPropertyDetails[T] =
  ColorPropertyDetails[T](
    target: target,
    propertyName: propertyName,
    start: start,
    changeR: changeR,
    changeG: changeG,
    changeB: changeB,
    changeA: changeA
  )
