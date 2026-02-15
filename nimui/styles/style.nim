type
  Style* = ref object
    left*: float
    top*: float
    width*: float
    height*: float
    color*: int
    fontSize*: float
    fontName*: string
    textAlign*: string
    wordWrap*: bool

proc newStyle*(): Style =
  Style()
