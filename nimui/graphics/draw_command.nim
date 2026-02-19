import nimui/util/color
import nimui/util/variant
import std/options

type
  DrawCommandKind* = enum
    dcClear,
    dcSetPixel,
    dcSetPixels,
    dcMoveTo,
    dcLineTo,
    dcStrokeStyle,
    dcCircle,
    dcFillStyle,
    dcCurveTo,
    dcCubicCurveTo,
    dcRectangle,
    dcImage,
    dcBeginPath,
    dcClosePath

  DrawCommand* = object
    case kind*: DrawCommandKind
    of dcClear: discard
    of dcSetPixel:
      x*, y*: float
      pixelColor*: Color
    of dcSetPixels:
      pixels*: seq[byte]
    of dcMoveTo, dcLineTo:
      posX*, posY*: float
    of dcStrokeStyle:
      strokeColor*: Option[Color]
      thickness*: Option[float]
      strokeAlpha*: Option[float]
    of dcCircle:
      circleX*, circleY*: float
      radius*: float
    of dcFillStyle:
      fillColor*: Option[Color]
      fillAlpha*: Option[float]
    of dcCurveTo:
      controlX*, controlY*: float
      anchorX*, anchorY*: float
    of dcCubicCurveTo:
      controlX1*, controlY1*: float
      controlX2*, controlY2*: float
      anchorX3*, anchorY3*: float
    of dcRectangle:
      rectX*, rectY*: float
      rectWidth*, rectHeight*: float
    of dcImage:
      resource*: Variant
      imgX*, imgY*: float
      imgWidth*, imgHeight*: float
    of dcBeginPath, dcClosePath: discard
