import nimui/util/color
import std/math

type
  HSV* = object
    h*, s*, v*: float

  RGBF* = object
    r*, g*, b*: float

proc toHSV*(c: Color): HSV =
  # Conversion logic
  return HSV(h: 0, s: 0, v: 0)

proc hsvToRGBF*(h, s, v: float): RGBF =
  # Conversion logic
  return RGBF(r: 0, g: 0, b: 0)

proc rgbToGray*(r, g, b: int): int =
  return (r + g + b) div 3
