import nimui/core/component
import nimui/core/types
import nimui/containers/box
import nimui/containers/hbox
import nimui/containers/vbox
import nimui/components/label
import nimui/behaviours/data_behaviour
import nimui/core/composite_builder
import nimui/util/variant

type
  Card* = ref object of Box

proc newCard*(): Card =
  new result
  initComponent(result)

# Builder
type
  CardBuilder* = ref object of CompositeBuilder

method getTitleContainer*(self: CardBuilder): VBox {.base.} =
  var titleContainer = cast[VBox](self.component.findComponent("card-title-container"))
  if titleContainer == nil:
    titleContainer = newVBox()
    titleContainer.addClass("card-title-container")
    titleContainer.idInternal = "card-title-container"
    self.component.addComponentAt(titleContainer, 0)
  return titleContainer

method getTitleLabel*(self: CardBuilder): Label {.base.} =
  let titleContainer = self.getTitleContainer()
  var titleLabel = cast[Label](titleContainer.findComponent("card-title-label"))
  if titleLabel == nil:
    # self.component.layoutName = "vertical"
    var hbox = cast[HBox](titleContainer.findComponent("card-title-box"))
    if hbox == nil:
      hbox = newHBox()
      hbox.addClass("card-title-box")
      hbox.idInternal = "card-title-box"
      titleContainer.addComponent(hbox)

    titleLabel = newLabel()
    titleLabel.addClass("card-title-label")
    titleLabel.idInternal = "card-title-label"
    hbox.addComponentAt(titleLabel, 0)

    var line = titleContainer.findComponent("card-title-line")
    if line == nil:
      line = newComponent()
      line.idInternal = "card-title-line"
      line.addClass("card-title-line")
      titleContainer.addComponent(line)

  return titleLabel

# Behaviours
type
  CardTextBehaviour* = ref object of DataBehaviour

method validateData*(self: CardTextBehaviour) =
  let builder = cast[CardBuilder](self.component.compositeBuilderInternal)
  builder.getTitleLabel().text = self.valueInternal.toString()

method createBuilder*(self: Card): CompositeBuilder =
  return CardBuilder(component: self)
