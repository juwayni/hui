import nimui/core/component
import nimui/core/types
import nimui/containers/box
import nimui/containers/header
import nimui/components/image
import nimui/components/label
import nimui/behaviours/data_behaviour
import nimui/core/composite_builder
import nimui/layouts/default_layout
import nimui/util/variant
import std/options

type
  Frame* = ref object of Box

proc newFrame*(): Frame =
  new result
  initComponent(result)

# Behaviours
type
  FrameTextBehaviour* = ref object of DataBehaviour
  FrameIconBehaviour* = ref object of DataBehaviour
  FrameCollapsibleBehaviour* = ref object of DataBehaviour
  FrameCollapsedBehaviour* = ref object of DataBehaviour

method validateData*(self: FrameTextBehaviour) =
  let label = cast[Label](self.component.findComponent("frame-title"))
  if label != nil:
    label.text = self.valueInternal.toString()

# Builder
type
  FrameBuilder* = ref object of CompositeBuilder
    cachedPercentHeight*: Option[float]
    cachedHeight*: Option[float]

method create*(self: FrameBuilder) =
  let border = newBox()
  border.idInternal = "frame-border"
  border.addClass("frame-border")
  border.includeInLayout = false
  self.component.addComponent(border)

  let contents = newBox()
  contents.idInternal = "frame-contents"
  contents.addClass("frame-contents")
  self.component.addComponent(contents)

  let label = newLabel()
  label.idInternal = "frame-title"
  label.addClass("frame-title")
  label.includeInLayout = false
  self.component.addComponent(label)

  let lineLeft = newComponent()
  lineLeft.idInternal = "frame-left-line"
  lineLeft.addClass("frame-left-line")
  lineLeft.includeInLayout = false
  self.component.addComponent(lineLeft)

  let lineRight = newComponent()
  lineRight.idInternal = "frame-right-line"
  lineRight.addClass("frame-right-line")
  lineRight.includeInLayout = false
  self.component.addComponent(lineRight)

method createBuilder*(self: Frame): CompositeBuilder =
  return FrameBuilder(component: self)

# Layout
type
  FrameLayout* = ref object of DefaultLayout

method createLayout*(self: Frame): Layout =
  return FrameLayout(component: self)
