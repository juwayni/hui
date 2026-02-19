import nimui/core/component
import nimui/core/types
import nimui/containers/box
import nimui/components/image
import nimui/styles/style
import nimui/util/variant

type
  Decorator* = ref object of Box

proc newDecorator*(): Decorator =
  new result
  result.initComponent()

method `icon=`*(self: Decorator, value: Variant) =
  var image = cast[Image](self.findComponent(Image))
  if image == nil:
    image = newImage()
    self.addComponent(image)
  image.resource = value

method applyStyle*(self: Decorator, style: Style) =
  procCall self.Box.applyStyle(style)
  if style.backgroundImage.isSome: # Using backgroundImage as icon proxy in Style for now
    self.icon = toVariant(style.backgroundImage.get())
