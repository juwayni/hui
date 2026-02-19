import macros

macro buildDraggable*(typeSection: untyped): untyped =
  # Adds drag properties and events to the component type
  result = typeSection
