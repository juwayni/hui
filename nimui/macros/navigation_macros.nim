import macros

macro buildNavigatableView*(typeSection: untyped): untyped =
  # Similar to buildNavigatableView in Haxe
  result = typeSection
