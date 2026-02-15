import nimui/core/types
import nimui/validation/ivalidating
import nimui/validation/validation_manager
import nimui/layouts/layout
import nimui/styles/style
import nimui/events/ui_event
import nimui/behaviours/behaviours
import std/options

# Forward declarations
method invalidateComponentLayout*(self: Component) {.base.}
method invalidateComponentStyle*(self: Component) {.base.}

# Methods for IValidating implementation
method depth*(self: Component): int = self.depthInternal
method `depth=`*(self: Component, value: int) = self.depthInternal = value

method id*(self: Component): string = self.idInternal
method `id=`*(self: Component, value: string) = self.idInternal = value

proc behaviours*(self: Component): Behaviours =
  if self.behavioursInternal == nil:
    self.behavioursInternal = cast[RootRef](newBehaviours(self))
  return cast[Behaviours](self.behavioursInternal)

method validateComponentStyle(self: Component) =
  if self.isStyleInvalidInternal:
    # Logic to build/apply style
    self.isStyleInvalidInternal = false

method validateComponentLayout(self: Component) =
  if self.isLayoutInvalidInternal:
    if self.layoutInternal != nil:
      self.layoutInternal.refreshLayout()
    self.isLayoutInvalidInternal = false

method validateComponent*(self: Component, nextFrame: bool = true) =
  if self.isAllInvalidInternal:
    self.validateComponentStyle()
    self.behaviours().validateData()
    self.isAllInvalidInternal = false

  self.validateComponentLayout()

method updateComponentDisplay*(self: Component) =
  # Update actual backend surface
  discard

# Invalidation helpers
method invalidateComponentLayout*(self: Component) =
  self.isLayoutInvalidInternal = true
  validation_manager.instance().add(self)

method invalidateComponentStyle*(self: Component) =
  self.isStyleInvalidInternal = true
  validation_manager.instance().add(self)

# Display tree
method addComponent*(self: Component, child: Component): Component {.base.} =
  child.parentComponent = self
  child.depthInternal = self.depthInternal + 1
  self.childComponents.add(child)
  self.invalidateComponentLayout()

  return child

# Properties
proc left*(self: Component): float = self.leftInternal
proc `left=`*(self: Component, value: float) =
  if self.leftInternal != value:
    self.leftInternal = value

proc top*(self: Component): float = self.topInternal
proc `top=`*(self: Component, value: float) =
  if self.topInternal != value:
    self.topInternal = value

proc width*(self: Component): float = self.widthInternal
proc `width=`*(self: Component, value: float) =
  if self.widthInternal != value:
    self.widthInternal = value
    self.invalidateComponentLayout()

proc height*(self: Component): float = self.heightInternal
proc `height=`*(self: Component, value: float) =
  if self.heightInternal != value:
    self.heightInternal = value
    self.invalidateComponentLayout()

proc percentWidth*(self: Component): Option[float] = self.percentWidthInternal
proc `percentWidth=`*(self: Component, value: Option[float]) =
  self.percentWidthInternal = value
  self.invalidateComponentLayout()

proc percentHeight*(self: Component): Option[float] = self.percentHeightInternal
proc `percentHeight=`*(self: Component, value: Option[float]) =
  self.percentHeightInternal = value
  self.invalidateComponentLayout()

# Initialization
proc newComponent*(): Component =
  new result
  result.childComponents = @[]
  result.includeInLayout = true
  result.depthInternal = -1
  result.styleInternal = newStyle()
