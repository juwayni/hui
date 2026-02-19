import nimui/focus/focus_applicator
import nimui/core/types
import nimui/core/component
import nimui/core/screen
import nimui/containers/box
import nimui/events/ui_event
import nimui/focus/focus_manager
import nimui/toolkit
import std/options

type
  BoxFocusApplicator* = ref object of FocusApplicator
    box: Box

proc newBoxFocusApplicator*(): BoxFocusApplicator =
  new result
  result.initFocusApplicator()

method createBox(self: BoxFocusApplicator) {.base.} =
  if self.box != nil: return
  self.box = newBox()
  self.box.idInternal = "boxFocus_indicator"
  self.box.styleString = "border: 1px solid $accent-color;pointer-events:none;background-color: $accent-color;background-opacity: .2;border-radius: 2px;"
  instance().addComponent(self.box)
  FocusManager.instance().removeView(self.box)

method animateBox(self: BoxFocusApplicator, target: Component) {.base.} =
  # Porting animation logic would require more infrastructure
  # For now, we update position directly on resize or focus
  let x = target.screenLeft
  let y = target.screenTop
  let w = target.width
  let h = target.height
  self.box.left = x
  self.box.top = y
  self.box.width = w
  self.box.height = h

  target.registerEvent("resize", proc(e: UIEvent) =
    self.box.left = target.screenLeft
    self.box.top = target.screenTop
    self.box.width = target.width
    self.box.height = target.height
  )

method apply*(self: BoxFocusApplicator, target: Component) =
  self.createBox()
  instance().moveComponentToFront(self.box)

  # Toolkit.callLater(proc() = self.animateBox(target))
  self.animateBox(target)

method unapply*(self: BoxFocusApplicator, target: Component) =
  # self.box.hidden = true
  discard
