import strutils
import pixie

type
  Color* = int32

const
  ColorWhite*: Color = 0xffffff.int32
  ColorBlack*: Color = 0x000000.int32

proc r*(c: Color): int = (c shr 16) and 0xFF
proc g*(c: Color): int = (c shr 8) and 0xFF
proc b*(c: Color): int = c and 0xFF
proc a*(c: Color): int = (c shr 24) and 0xFF

proc colorFromComponents*(r, g, b, a: int): Color =
  ((a and 0xFF) shl 24).int32 or ((r and 0xFF) shl 16).int32 or ((g and 0xFF) shl 8).int32 or (b and 0xFF).int32

proc toPixie*(c: Color): pixie.Color =
  rgb(c.r.uint8, c.g.uint8, c.b.uint8)

proc toPixieWithAlpha*(c: Color): pixie.Color =
  rgba(c.r.uint8, c.g.uint8, c.b.uint8, c.a.uint8)
