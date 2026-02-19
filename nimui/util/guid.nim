import math, random

randomize()

proc randomIntegerWithinRange*(minVal, maxVal: int): int =
  return rand(minVal .. maxVal)

proc createRandomIdentifier*(length: int, radix: int = 61): string =
  const characters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  var id = ""
  let actualRadix = min(radix, 61)
  for i in 0 ..< length:
    id.add(characters[randomIntegerWithinRange(0, actualRadix)])
  return id

proc uuid*(): string =
  const specialChars = "89AB"
  return createRandomIdentifier(8, 15) & "-" &
         createRandomIdentifier(4, 15) & "-4" &
         createRandomIdentifier(3, 15) & "-" &
         $specialChars[randomIntegerWithinRange(0, 3)] &
         createRandomIdentifier(3, 15) & "-" &
         createRandomIdentifier(12, 15)
