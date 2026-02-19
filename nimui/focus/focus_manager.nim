import nimui/backend/focus_manager_impl
import nimui/core/types
import nimui/core/component
import nimui/core/screen
import nimui/events/ui_event
import nimui/events/mouse_event
import nimui/focus/ifocus_applicator
import nimui/focus/ifocusable
import nimui/focus/style_focus_applicator
import std/tables
import std/algorithm

type
  FocusManager* = ref object of FocusManagerImpl
    autoFocus*: bool
    enabled*: bool
    applicators: seq[FocusApplicator] # Using concrete for now or I'll need a better way to handle seq[concept]
    lastFocuses: Table[Component, Component] # Component is the root, value is the focusable component cast to Component

var focusManagerInstance: FocusManager

proc instance*(): FocusManager =
  if focusManagerInstance == nil:
    new focusManagerInstance
    focusManagerInstance.initFocusManagerImpl()
    focusManagerInstance.autoFocus = true
    focusManagerInstance.enabled = true
    focusManagerInstance.applicators = @[]
    focusManagerInstance.applicators.add(newStyleFocusApplicator())
    focusManagerInstance.lastFocuses = initTable[Component, Component]()

    instance().registerEvent("mousedown", proc(e: UIEvent) =
      let me = cast[MouseEvent](e)
      let list = instance().findComponentsUnderPoint(me.screenX, me.screenY)
      for l in list:
        if l of InteractiveComponent: # Close enough to IFocusable
          return

      focusManagerInstance.setFocus(nil)
    )
  return focusManagerInstance

method buildFocusableList(self: FocusManager, c: Component, list: var seq[Component], considerAutoFocus: bool = false): Component {.base.} =
  if not self.enabled: return nil
  var currentFocus: Component = nil

  if c == nil or c.isDisposedInternal: return nil
  if c.hidden(): return nil

  if c of InteractiveComponent:
    let f = cast[InteractiveComponent](c)
    if considerAutoFocus and not f.autoFocus():
      # Skip
      discard
    elif f.allowFocus() and not f.disabledInternal:
      if f.focus():
        currentFocus = f
      list.add(f)

  var childList = c.childComponents
  childList.sort(proc(c1, c2: Component): int =
    return c1.componentTabIndex - c2.componentTabIndex
  )

  for child in childList:
    let f = self.buildFocusableList(child, list, considerAutoFocus)
    if f != nil:
      currentFocus = f

  return currentFocus

method applyFocus*(self: FocusManager, c: Component) =
  procCall self.FocusManagerImpl.applyFocus(c)
  if c of InteractiveComponent:
    cast[InteractiveComponent](c).focus = true
  for a in self.applicators:
    if a.enabled():
      a.apply(c)

method unapplyFocus*(self: FocusManager, c: Component) =
  procCall self.FocusManagerImpl.unapplyFocus(c)
  if c of InteractiveComponent:
    cast[InteractiveComponent](c).focus = false
  for a in self.applicators:
    if a.enabled():
      a.unapply(c)

method setFocus*(self: FocusManager, value: Component) {.base.} =
  if value != nil:
    let root = value.rootComponent()
    # Logic to unapply previous focus and apply new one
    if self.lastFocuses.hasKey(root):
      let last = self.lastFocuses[root]
      if last != value:
        self.unapplyFocus(last)

    self.lastFocuses[root] = value
    self.applyFocus(value)
  else:
    # Handle nil focus (unfocus)
    discard

method pushView*(self: FocusManager, view: Component) {.base.} =
  # Porting pushView logic
  discard

method removeView*(self: FocusManager, view: Component) {.base.} =
  self.lastFocuses.del(view)
