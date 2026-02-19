import nimui/core/types
import nimui/validation/ivalidating
import nimui/validation/validation_manager
import nimui/layouts/layout
import nimui/styles/style
import nimui/events/ui_event
import nimui/behaviours/behaviours
import nimui/util/event_map
import std/options
import nimui/styles/animation/animation
import nimui/styles/elements/animation_key_frames
import nimui/util/variant
import nimui/util/string_util
import nimui/core/component_field_map
import nimui/styles/composite_style_sheet
import nimui/util/color
import nimui/geom/rectangle
import nimui/geom/size
import tables

# Forward declarations
method screenLeft*(self: Component): float {.gcsafe.}
method screenTop*(self: Component): float {.gcsafe.}
proc left*(self: Component): float {.gcsafe.}
proc `left=`*(self: Component, value: float) {.gcsafe.}
proc top*(self: Component): float {.gcsafe.}
proc `top=`*(self: Component, value: float) {.gcsafe.}
proc width*(self: Component): float {.gcsafe.}
proc `width=`*(self: Component, value: float) {.gcsafe.}
proc height*(self: Component): float {.gcsafe.}
proc `height=`*(self: Component, value: float) {.gcsafe.}
proc percentWidth*(self: Component): Option[float] {.gcsafe.}
proc `percentWidth=`*(self: Component, value: Option[float]) {.gcsafe.}
proc percentHeight*(self: Component): Option[float] {.gcsafe.}
proc `percentHeight=`*(self: Component, value: Option[float]) {.gcsafe.}
proc newComponent*(): Component
proc customStyle*(self: Component): Style
proc hidden*(self: Component): bool {.gcsafe.}
proc `hidden=`*(self: Component, value: bool) {.gcsafe.}
proc addClass*(self: Component, className: string, invalidate: bool = true, recursive: bool = false) {.gcsafe.}
proc removeClass*(self: Component, className: string, invalidate: bool = true, recursive: bool = false) {.gcsafe.}
method invalidateComponentLayout*(self: Component, recursively: bool = false) {.base, gcsafe.}
method invalidateComponentStyle*(self: Component, recursively: bool = false) {.base, gcsafe.}
method invalidateComponentData*(self: Component) {.base, gcsafe.}
method applyAnimationKeyFrame*(self: Component, frames: AnimationKeyFrames, options: AnimationOptions) {.base, gcsafe.}
method handleCreate*(self: Component, native: Option[bool]) {.base, gcsafe.} = discard
method handleAddComponent*(self: Component, child: Component) {.base, gcsafe.} = discard
method handleRemoveComponent*(self: Component, child: Component, dispose: bool) {.base, gcsafe.} = discard
method handleAddComponentAt*(self: Component, child: Component, index: int) {.base, gcsafe.} = discard
method handleRemoveComponentAt*(self: Component, index: int, dispose: bool) {.base, gcsafe.} = discard
method handleDestroy*(self: Component) {.base, gcsafe.} = discard
method handleVisibility*(self: Component, show: bool) {.base, gcsafe.} = discard
method handleReady*(self: Component) {.base, gcsafe.} = discard
method handlePosition*(self: Component, left, top: float, style: Style) {.base, gcsafe.} = discard
method handleSize*(self: Component, width, height: float, style: Style) {.base, gcsafe.} = discard
method handleClipRect*(self: Component, rect: Rectangle) {.base, gcsafe.} = discard

method hitTest*(self: Component, x, y: float, allowZeroSized: bool = false): bool {.base.} =
  if self.styleInternal.hidden.get(false): return false
  if not allowZeroSized and (self.widthInternal <= 0 or self.heightInternal <= 0): return false

  let sx = self.screenLeft
  let sy = self.screenTop
  return x >= sx and x <= sx + self.widthInternal and
         y >= sy and y <= sy + self.heightInternal

method screenLeft*(self: Component): float =
  var x = self.leftInternal
  var p = self.parentComponent
  while p != nil:
    x += p.leftInternal
    p = p.parentComponent
  return x

method screenTop*(self: Component): float =
  var y = self.topInternal
  var p = self.parentComponent
  while p != nil:
    y += p.topInternal
    p = p.parentComponent
  return y

# Methods for IValidating implementation
method depth*(self: Component): int = self.depthInternal
method `depth=`*(self: Component, value: int) = self.depthInternal = value

method id*(self: Component): string = self.idInternal
method `id=`*(self: Component, value: string) = self.idInternal = value

proc behaviours*(self: Component): Behaviours =
  if self.behavioursInternal == nil:
    self.behavioursInternal = newBehaviours(self)
  return cast[Behaviours](self.behavioursInternal)

proc events*(self: Component): EventMap =
  if self.eventsInternal == nil:
    self.eventsInternal = newEventMap()
  return cast[EventMap](self.eventsInternal)

method registerEvent*(self: Component, eventType: string, listener: proc(e: UIEvent) {.gcsafe.}, priority: int = 0) {.base.} =
  discard self.events().add(eventType, listener, priority)

method unregisterEvent*(self: Component, eventType: string, listener: proc(e: UIEvent) {.gcsafe.}) {.base.} =
  discard self.events().remove(eventType, listener)

method dispatch*(self: Component, event: UIEvent) {.base, gcsafe.} =
  if event.target == nil:
    event.target = self
  self.events().invoke(event.`type`, event, self)

  if event.bubble and self.parentComponent != nil and not event.canceled:
    self.parentComponent.dispatch(event)

proc dispatchRecursively*(self: Component, event: UIEvent) {.gcsafe.} =
  self.dispatch(event)
  for child in self.childComponents:
    child.dispatchRecursively(event)

# Properties
proc native*(self: Component): bool = self.nativeInternal.get(false)
proc `native=`*(self: Component, value: bool) =
  if self.nativeInternal.isSome and self.nativeInternal.get() == value: return
  self.nativeInternal = some(value)

proc animatable*(self: Component): bool = self.animatableInternal
proc `animatable=`*(self: Component, value: bool) =
  if self.animatableInternal != value:
    if not value and self.componentAnimationInternal != nil:
      cast[Animation](self.componentAnimationInternal).stop()
      self.componentAnimationInternal = nil
    self.animatableInternal = value

proc recursivePointerEvents*(self: Component): bool = self.recursivePointerEventsInternal
proc `recursivePointerEvents=`*(self: Component, value: bool) = self.recursivePointerEventsInternal = value

proc pauseAnimationStyleChanges*(self: Component): bool = self.pauseAnimationStyleChangesInternal
proc `pauseAnimationStyleChanges=`*(self: Component, value: bool) = self.pauseAnimationStyleChangesInternal = value

proc componentAnimation*(self: Component): Animation = cast[Animation](self.componentAnimationInternal)
proc `componentAnimation=`*(self: Component, value: Animation) =
  if self.componentAnimationInternal != cast[RootRef](value) and self.animatableInternal:
    if self.componentAnimationInternal != nil:
      cast[Animation](self.componentAnimationInternal).stop()
    self.componentAnimationInternal = cast[RootRef](value)

# Construction
method create*(self: Component) {.base.} =
  self.handleCreate(self.nativeInternal)
  self.behaviours().applyDefaults()

# Validation logic
proc enforceSizeConstraints(self: Component) =
  let style = self.styleInternal
  if style.minWidth.isSome and self.widthInternal < style.minWidth.get:
    self.widthInternal = style.minWidth.get
  if style.maxWidth.isSome and self.widthInternal > style.maxWidth.get:
    self.widthInternal = style.maxWidth.get
  if style.minHeight.isSome and self.heightInternal < style.minHeight.get:
    self.heightInternal = style.minHeight.get
  if style.maxHeight.isSome and self.heightInternal > style.maxHeight.get:
    self.heightInternal = style.maxHeight.get

method validateComponentAutoSize(self: Component): bool {.base.} =
  var invalidated = false
  if self.autoWidth or self.autoHeight:
    if self.layoutInternal != nil:
      let s = self.layoutInternal.calcAutoSize()
      if self.autoWidth and s.width != self.widthInternal:
        self.widthInternal = s.width
        invalidated = true
      if self.autoHeight and s.height != self.heightInternal:
        self.heightInternal = s.height
        invalidated = true
  return invalidated

method validateComponentLayout*(self: Component, recursively: bool = false) =
  if self.isLayoutInvalidInternal:
    if self.layoutInternal != nil:
      self.layoutInternal.refreshLayout()

    while self.validateComponentAutoSize():
      if self.layoutInternal != nil:
        self.layoutInternal.refreshLayout()

    self.enforceSizeConstraints()
    self.isLayoutInvalidInternal = false
    if self.parentComponent != nil:
      self.parentComponent.invalidateComponentLayout()
    self.dispatch(newUIEvent(UIEventResize))

method validateComponentStyle*(self: Component, recursively: bool = false) =
  if self.isStyleInvalidInternal:
    # Build style from stylesheet and customStyle
    self.isStyleInvalidInternal = false

method validateComponentData*(self: Component) =
  if self.isDataInvalidInternal:
    self.behaviours().validateData()
    self.isDataInvalidInternal = false

method validateComponentPosition(self: Component) =
  if self.isPositionInvalidInternal:
    self.handlePosition(self.leftInternal, self.topInternal, self.styleInternal)
    self.isPositionInvalidInternal = false
    self.dispatch(newUIEvent(UIEventMove))

method validateComponent*(self: Component, nextFrame: bool = true) =
  if self.isAllInvalidInternal:
    self.validateComponentStyle()
    self.validateComponentData()
    self.isAllInvalidInternal = false

  self.validateComponentData()
  self.validateComponentStyle()
  self.validateComponentLayout()
  self.validateComponentPosition()

method updateComponentDisplay*(self: Component) =
  if self.widthInternal > 0 and self.heightInternal > 0:
    self.handleSize(self.widthInternal, self.heightInternal, self.styleInternal)

proc onPointerEventsMouseOver(e: UIEvent) {.gcsafe.} =
  let c = e.target
  {.cast(gcsafe).}:
    c.addClass(":hover", true, c.recursivePointerEvents)

proc onPointerEventsMouseOut(e: UIEvent) {.gcsafe.} =
  let c = e.target
  {.cast(gcsafe).}:
    c.removeClass(":hover", true, c.recursivePointerEvents)

proc onPointerEventsMouseDown(e: UIEvent) {.gcsafe.} =
  let c = e.target
  {.cast(gcsafe).}:
    c.addClass(":down", true, c.recursivePointerEvents)

proc onPointerEventsMouseUp(e: UIEvent) {.gcsafe.} =
  let c = e.target
  {.cast(gcsafe).}:
    c.removeClass(":down", true, c.recursivePointerEvents)

method applyStyle*(self: Component, style: Style) {.base.} =
  if style == nil: return

  if not self.initialSizeAppliedInternal:
    if (style.initialWidth.isSome or style.initialPercentWidth.isSome) and (self.widthInternal <= 0 and self.percentWidthInternal.isNone):
      if style.initialWidth.isSome:
        self.width = style.initialWidth.get
        self.initialSizeAppliedInternal = true
      elif style.initialPercentWidth.isSome:
        self.percentWidth = style.initialPercentWidth
        self.initialSizeAppliedInternal = true

    if (style.initialHeight.isSome or style.initialPercentHeight.isSome) and (self.heightInternal <= 0 and self.percentHeightInternal.isNone):
      if style.initialHeight.isSome:
        self.height = style.initialHeight.get
        self.initialSizeAppliedInternal = true
      elif style.initialPercentHeight.isSome:
        self.percentHeight = style.initialPercentHeight
        self.initialSizeAppliedInternal = true

  if style.left.isSome: self.left = style.left.get
  if style.top.isSome: self.top = style.top.get

  if style.percentWidth.isSome:
    self.widthInternal = 0
    self.percentWidth = style.percentWidth
  if style.percentHeight.isSome:
    self.heightInternal = 0
    self.percentHeight = style.percentHeight
  if style.width.isSome:
    self.percentWidth = none(float)
    self.width = style.width.get
  if style.height.isSome:
    self.percentHeight = none(float)
    self.height = style.height.get

  if style.native.isSome: self.native = style.native.get
  if style.hidden.isSome: self.hidden = style.hidden.get

  if not self.pauseAnimationStyleChangesInternal:
    if style.animationName.isSome:
      let frames = composite_style_sheet.instance().animations().getOrDefault(style.animationName.get())
      if frames != nil:
        self.applyAnimationKeyFrame(frames, cast[AnimationOptions](style.animationOptionsInternal))
    elif self.componentAnimationInternal != nil:
      self.componentAnimationInternal = nil

  if style.pointerEvents.isSome and style.pointerEvents.get() != "none":
    self.registerEvent("mouseover", onPointerEventsMouseOver)
    self.registerEvent("mouseout", onPointerEventsMouseOut)
    self.registerEvent("mousedown", onPointerEventsMouseDown)
    self.registerEvent("mouseup", onPointerEventsMouseUp)
  elif style.pointerEvents.isSome:
    self.unregisterEvent("mouseover", onPointerEventsMouseOver)
    self.unregisterEvent("mouseout", onPointerEventsMouseOut)
    self.unregisterEvent("mousedown", onPointerEventsMouseDown)
    self.unregisterEvent("mouseup", onPointerEventsMouseUp)

  if style.includeInLayout.isSome:
    self.includeInLayout = style.includeInLayout.get

# Invalidation helpers
method invalidateComponentLayout*(self: Component, recursively: bool = false) {.gcsafe.} =
  self.isLayoutInvalidInternal = true
  {.cast(gcsafe).}:
    validation_manager.instance().add(self)
  if recursively:
    for child in self.childComponents: child.invalidateComponentLayout(true)

method invalidateComponentStyle*(self: Component, recursively: bool = false) {.gcsafe.} =
  self.isStyleInvalidInternal = true
  {.cast(gcsafe).}:
    validation_manager.instance().add(self)
  if recursively:
    for child in self.childComponents: child.invalidateComponentStyle(true)

method invalidateComponentData*(self: Component) {.gcsafe.} =
  self.isDataInvalidInternal = true
  {.cast(gcsafe).}:
    validation_manager.instance().add(self)

method applyAnimationKeyFrame*(self: Component, frames: AnimationKeyFrames, options: AnimationOptions) {.gcsafe.} =
  let anim = createWithKeyFrames(frames, self, options)
  self.componentAnimationInternal = cast[RootRef](anim)
  anim.run(proc() =
    discard
  )

# Classes
proc addClass*(self: Component, className: string, invalidate: bool = true, recursive: bool = false) {.gcsafe.} =
  if not self.classesInternal.contains(className):
    self.classesInternal.add(className)
    if invalidate:
      self.invalidateComponentStyle()
  if recursive:
    for child in self.childComponents: child.addClass(className, invalidate, true)

proc removeClass*(self: Component, className: string, invalidate: bool = true, recursive: bool = false) {.gcsafe.} =
  let idx = self.classesInternal.find(className)
  if idx != -1:
    self.classesInternal.delete(idx)
    if invalidate:
      self.invalidateComponentStyle()
  if recursive:
    for child in self.childComponents: child.removeClass(className, invalidate, true)

proc hasClass*(self: Component, className: string): bool =
  return self.classesInternal.contains(className)

proc addClasses*(self: Component, classNames: seq[string], invalidate: bool = true, recursive: bool = false) =
  for c in classNames: self.addClass(c, false, recursive)
  if invalidate: self.invalidateComponentStyle()

proc removeClasses*(self: Component, classNames: seq[string], invalidate: bool = true, recursive: bool = false) =
  for c in classNames: self.removeClass(c, false, recursive)
  if invalidate: self.invalidateComponentStyle()

proc swapClass*(self: Component, add, remove: string, invalidate: bool = true, recursive: bool = false) =
  self.removeClass(remove, false, recursive)
  self.addClass(add, false, recursive)
  if invalidate: self.invalidateComponentStyle()

proc toggleClass*(self: Component, className: string, invalidate: bool = true, recursive: bool = false) =
  if self.hasClass(className): self.removeClass(className, invalidate, recursive)
  else: self.addClass(className, invalidate, recursive)

# Display tree
proc rootComponent*(self: Component): Component =
  var r = self
  while r.parentComponent != nil:
    r = r.parentComponent
  return r

proc numComponents*(self: Component): int =
  return self.childComponents.len

proc assignPositionClasses*(self: Component, invalidate: bool = true) =
  var effectiveChildren: seq[Component] = @[]
  for c in self.childComponents:
    effectiveChildren.add(c)

  if effectiveChildren.len == 1:
    effectiveChildren[0].addClasses(@["first", "last"], invalidate)
    return

  for n, c in effectiveChildren:
    if n == 0:
      c.swapClass("first", "last", invalidate)
    elif n == effectiveChildren.len - 1:
      c.swapClass("last", "first", invalidate)
    else:
      c.removeClasses(@["first", "last"], invalidate)

method addComponent*(self: Component, child: Component): Component {.base.} =
  child.parentComponent = self
  child.isDisposedInternal = false
  self.childComponents.add(child)
  self.handleAddComponent(child)
  self.assignPositionClasses()
  self.invalidateComponentLayout()
  self.dispatch(newUIEvent(UIEventComponentAdded))
  return child

method removeComponent*(self: Component, child: Component, dispose: bool = true, invalidate: bool = true): Component {.base.} =
  if child == nil: return nil
  let idx = self.childComponents.find(child)
  if idx != -1:
    self.childComponents.delete(idx)
    child.parentComponent = nil
    child.depthInternal = -1

  self.handleRemoveComponent(child, dispose)
  self.assignPositionClasses(invalidate)
  if invalidate: self.invalidateComponentLayout()
  self.dispatch(newUIEvent(UIEventComponentRemoved))
  return child

method removeComponentAt*(self: Component, index: int, dispose: bool = true, invalidate: bool = true): Component {.base.} =
  if index < 0 or index >= self.childComponents.len: return nil
  let child = self.childComponents[index]
  return self.removeComponent(child, dispose, invalidate)

proc removeAllComponents*(self: Component, dispose: bool = true) =
  while self.childComponents.len > 0:
    discard self.removeComponent(self.childComponents[0], dispose, false)
  self.invalidateComponentLayout()

proc walkComponents*(self: Component, callback: proc(c: Component): bool {.gcsafe.}) =
  if not callback(self): return
  for child in self.childComponents:
    child.walkComponents(callback)

proc matchesSearch*(self: Component, criteria: string, searchType: string = "id"): bool =
  if criteria == "": return false
  if searchType == "id":
    return self.idInternal == criteria
  elif searchType == "css":
    return self.hasClass(criteria)
  return false

proc findComponent*(self: Component, criteria: string = "", recursive: bool = true, searchType: string = "id"): Component =
  for child in self.childComponents:
    if child.matchesSearch(criteria, searchType):
      return child

  if recursive:
    for child in self.childComponents:
      let match = child.findComponent(criteria, recursive, searchType)
      if match != nil: return match
  return nil

proc findAncestor*(self: Component, criteria: string = "", searchType: string = "id"): Component =
  var p = self.parentComponent
  while p != nil:
    if p.matchesSearch(criteria, searchType):
      return p
    p = p.parentComponent
  return nil

proc findComponentsUnderPoint*(self: Component, screenX, screenY: float): seq[Component] =
  var c: seq[Component] = @[]
  if self.hitTest(screenX, screenY, false):
    for child in self.childComponents:
      if child.hitTest(screenX, screenY, false):
        c.add(child)
        c.add(child.findComponentsUnderPoint(screenX, screenY))
  return c

proc hasComponentUnderPoint*(self: Component, screenX, screenY: float): bool =
  if self.hitTest(screenX, screenY, false):
    return true
  return false

proc getComponentIndex*(self: Component, child: Component): int =
  return self.childComponents.find(child)

proc setComponentIndex*(self: Component, child: Component, index: int): Component =
  if index >= 0 and index <= self.childComponents.len and child.parentComponent == self:
    let oldIdx = self.childComponents.find(child)
    if oldIdx != -1:
      self.childComponents.delete(oldIdx)
      self.childComponents.insert(child, index)
      self.invalidateComponentLayout()
  return child

proc getComponentAt*(self: Component, index: int): Component =
  if index < 0 or index >= self.childComponents.len: return nil
  return self.childComponents[index]

proc hide*(self: Component) {.gcsafe.} =
  if not self.styleInternal.hidden.get(false):
    self.styleInternal.hidden = some(true)
    self.handleVisibility(false)
    if self.parentComponent != nil: self.parentComponent.invalidateComponentLayout()
    self.dispatchRecursively(newUIEvent(UIEventHidden))

proc show*(self: Component) {.gcsafe.} =
  if self.styleInternal.hidden.get(false):
    self.styleInternal.hidden = some(false)
    self.handleVisibility(true)
    self.invalidateComponentLayout()
    if self.parentComponent != nil: self.parentComponent.invalidateComponentLayout()
    self.dispatchRecursively(newUIEvent(UIEventShown))

proc hidden*(self: Component): bool {.gcsafe.} =
  if self.styleInternal.hidden.get(false): return true
  if self.parentComponent != nil: return self.parentComponent.hidden()
  return false

proc `hidden=`*(self: Component, value: bool) {.gcsafe.} =
  if value == self.hidden(): return
  if value: self.hide() else: self.show()

# Layout
proc lockLayout*(self: Component, recursive: bool = false) = discard
proc unlockLayout*(self: Component, recursive: bool = false) =
  self.invalidateComponentLayout()

# Styles properties
proc backgroundColor*(self: Component): Color = self.styleInternal.backgroundColor.get(Color(0))
proc `backgroundColor=`*(self: Component, value: Color) =
  self.styleInternal.backgroundColor = some(value)
  self.invalidateComponentStyle()

proc color*(self: Component): Color = self.styleInternal.color.get(Color(0))
proc `color=`*(self: Component, value: Color) =
  self.styleInternal.color = some(value)
  self.invalidateComponentStyle()

# Ready
proc ready*(self: Component) =
  if not self.isReadyInternal:
    self.isReadyInternal = true
    self.handleReady()
    for child in self.childComponents: child.ready()
    self.invalidateComponentStyle()
    self.invalidateComponentLayout()
    self.dispatch(newUIEvent(UIEventReady))

# Script related
proc namedComponents*(self: Component): seq[Component] =
  var list: seq[Component] = @[]
  self.walkComponents(proc(c: Component): bool =
    if c.id != "": list.add(c)
    return true
  )
  return list

# Properties Accessors
proc left*(self: Component): float {.gcsafe.} = self.leftInternal
proc `left=`*(self: Component, value: float) {.gcsafe.} =
  if self.leftInternal != value:
    self.leftInternal = value
    self.isPositionInvalidInternal = true
    {.cast(gcsafe).}:
      validation_manager.instance().add(self)

proc top*(self: Component): float {.gcsafe.} = self.topInternal
proc `top=`*(self: Component, value: float) {.gcsafe.} =
  if self.topInternal != value:
    self.topInternal = value
    self.isPositionInvalidInternal = true
    {.cast(gcsafe).}:
      validation_manager.instance().add(self)

proc width*(self: Component): float {.gcsafe.} = self.widthInternal
proc `width=`*(self: Component, value: float) {.gcsafe.} =
  if self.widthInternal != value:
    self.widthInternal = value
    self.invalidateComponentLayout()

proc height*(self: Component): float {.gcsafe.} = self.heightInternal
proc `height=`*(self: Component, value: float) {.gcsafe.} =
  if self.heightInternal != value:
    self.heightInternal = value
    self.invalidateComponentLayout()

proc percentWidth*(self: Component): Option[float] {.gcsafe.} = self.percentWidthInternal
proc `percentWidth=`*(self: Component, value: Option[float]) {.gcsafe.} =
  self.percentWidthInternal = value
  self.invalidateComponentLayout()

proc percentHeight*(self: Component): Option[float] {.gcsafe.} = self.percentHeightInternal
proc `percentHeight=`*(self: Component, value: Option[float]) {.gcsafe.} =
  self.percentHeightInternal = value
  self.invalidateComponentLayout()

method cloneComponent*(self: Component): Component =
  result = newComponent()
  if self.layoutInternal != nil:
    # result.layout = self.layoutInternal.cloneLayout() # Layout doesn't have clone yet
    discard

  if self.hidden(): result.hide()
  if not self.autoWidth and self.widthInternal > 0: result.width = self.widthInternal
  if not self.autoHeight and self.heightInternal > 0: result.height = self.heightInternal

  if self.customStyleInternal != nil:
    result.customStyle().apply(self.customStyleInternal)

  result.id = self.idInternal
  return result

# Initialization
proc initComponent*(self: Component) =
  self.childComponents = @[]
  self.classesInternal = @[]
  self.includeInLayout = true
  self.depthInternal = -1
  self.styleInternal = newStyle()
  self.customStyleInternal = newStyle()
  self.animatableInternal = true
  self.allowDispose = true
  self.recursivePointerEventsInternal = true

proc customStyle*(self: Component): Style =
  if self.customStyleInternal == nil:
    self.customStyleInternal = newStyle()
  return self.customStyleInternal

method cssName*(self: Component): string {.base.} =
  return "component"

proc isComponentSolid*(self: Component): bool =
  let s = self.styleInternal
  if s == nil: return false

  if s.backgroundColor.isSome or s.backgroundImage.isSome:
    if s.opacity.get(1.0) > 0:
      if s.backgroundOpacity.get(1.0) > 0:
        return true
  return false

proc newComponent*(): Component =
  new result
  initComponent(result)

# setProperty / getProperty implementations for Component
method setProperty*(self: Component, name: string, value: Variant) {.gcsafe.} =
  var mapped: string
  {.cast(gcsafe).}:
    mapped = mapField(name)
  case mapped:
    of "id": self.id = value.toString()
    of "left": self.left = value.toFloat()
    of "top": self.top = value.toFloat()
    of "width": self.width = value.toFloat()
    of "height": self.height = value.toFloat()
    of "hidden": self.hidden = value.toBool()
    of "backgroundColor": self.backgroundColor = color.fromInt(value.toInt())
    of "color": self.color = color.fromInt(value.toInt())
    else: discard

method getProperty*(self: Component, name: string): Variant {.gcsafe.} =
  var mapped: string
  {.cast(gcsafe).}:
    mapped = mapField(name)
  case mapped:
    of "id": return toVariant(self.id)
    of "left": return toVariant(self.left)
    of "top": return toVariant(self.top)
    of "width": return toVariant(self.width)
    of "height": return toVariant(self.height)
    of "hidden": return toVariant(self.hidden())
    of "backgroundColor": return toVariant(self.backgroundColor().toInt())
    of "color": return toVariant(self.color().toInt())
    else: return toVariant(nil)
