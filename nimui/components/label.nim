import nimui/core/component
import nimui/core/types
import nimui/layouts/default_layout
import nimui/behaviours/data_behaviour
import nimui/core/composite_builder
import nimui/geom/size
import nimui/events/ui_event
import nimui/util/variant
import nimui/styles/style
import std/options

type
  Label* = ref object of Component
    textAlignInternal*: string
    wordWrapInternal*: bool

proc newLabel*(): Label =
  new result
  result.initComponent()

# Layout
type
  LabelLayout* = ref object of DefaultLayout

method resizeChildren*(self: LabelLayout) =
  let component = cast[Label](self.component)
  if not component.autoWidth:
    component.getTextDisplay().width = component.widthInternal - self.paddingLeft - self.paddingRight
    component.getTextDisplay().wordWrap = component.styleInternal.wordWrap.get(false)
  else:
    component.getTextDisplay().width = component.getTextDisplay().textWidth

  if component.autoHeight:
    component.getTextDisplay().height = component.getTextDisplay().textHeight
  else:
    component.getTextDisplay().height = component.heightInternal

method repositionChildren*(self: LabelLayout) =
  let component = cast[Label](self.component)
  if component.hasTextDisplay():
    component.getTextDisplay().left = self.paddingLeft
    component.getTextDisplay().top = self.paddingTop

method calcAutoSize*(self: LabelLayout, exclusions: seq[Component] = @[]): Size =
  var size = procCall self.DefaultLayout.calcAutoSize(exclusions)
  let component = cast[Label](self.component)
  if component.hasTextDisplay():
    size.width += component.getTextDisplay().textWidth
    size.height += component.getTextDisplay().textHeight
  return size

# Behaviours
type
  LabelTextBehaviour* = ref object of DataBehaviour

method validateData*(self: LabelTextBehaviour) =
  let component = cast[Label](self.component)
  component.getTextDisplay().text = self.valueInternal.toString()
  component.dispatch(newUIEvent(UIEvent.CHANGE))

# Builder
type
  LabelBuilder* = ref object of CompositeBuilder

method applyStyle*(self: LabelBuilder, style: Style) =
  let component = cast[Label](self.component)
  if component.hasTextDisplay():
    component.getTextDisplay().textStyle = style

method createLayout*(self: Label): Layout =
  return LabelLayout(component: self)

method createBuilder*(self: Label): CompositeBuilder =
  return LabelBuilder(component: self)
