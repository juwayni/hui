type
  Size* = object
    width*, height*: float

proc newSize*(width: float = 0, height: float = 0): Size =
  Size(width: width, height: height)

proc toString*(self: Size): string =
  "[" & $self.width & "x" & $self.height & "]"
