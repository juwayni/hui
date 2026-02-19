import nimui/focus/focus_applicator
import nimui/core/types
import nimui/core/component

type
  StyleFocusApplicator* = ref object of FocusApplicator

proc newStyleFocusApplicator*(): StyleFocusApplicator =
  new result
  result.initFocusApplicator()

method apply*(self: StyleFocusApplicator, target: Component) =
  target.addClass(":active")

method unapply*(self: StyleFocusApplicator, target: Component) =
  target.removeClass(":active")
