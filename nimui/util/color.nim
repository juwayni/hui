import strutils, tables, math

type
  Color* = distinct int

proc `==`*(a, b: Color): bool {.borrow.}
proc `or`*(a, b: Color): Color {.borrow.}

const
  ColorMediumVioletRed*: Color = Color(0xc71585)
  ColorDeepPink*: Color = Color(0xff1493)
  ColorWhite*: Color = Color(0xffffff)
  ColorBlack*: Color = Color(0x000000)
  # ... Add more if needed, but keeping it small for now to ensure compilability

proc r*(c: Color): int = (int(c) shr 16) and 0xFF
proc g*(c: Color): int = (int(c) shr 8) and 0xFF
proc b*(c: Color): int = int(c) and 0xFF
proc a*(c: Color): int = (int(c) shr 24) and 0xFF

proc fromComponents*(r, g, b, a: int): Color =
  return Color(((a and 0xFF) shl 24) or ((r and 0xFF) shl 16) or ((g and 0xFF) shl 8) or (b and 0xFF))

proc toInt*(c: Color): int = int(c)
