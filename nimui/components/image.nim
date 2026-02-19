import nimui/core/component
import nimui/core/types
import nimui/core/composite_builder
import nimui/layouts/default_layout
import nimui/behaviours/data_behaviour
import nimui/behaviours/default_behaviour
import nimui/behaviours/invalidating_behaviour
import nimui/util/variant
import nimui/geom/size
import nimui/geom/rectangle
import std/options

type
  Image* = ref object of Component
    originalWidthInternal*: float
    originalHeightInternal*: float
    imageScaleInternal*: float

proc newImage*(): Image =
  new result
  result.initComponent()
  result.imageScaleInternal = 1.0

# Layout
type
  ImageLayout* = ref object of DefaultLayout

method resizeChildren*(self: ImageLayout) =
  let image = cast[Image](self.component)
  # Image display scaling logic
  discard

method repositionChildren*(self: ImageLayout) =
  # Image display alignment logic
  discard

method calcAutoSize*(self: ImageLayout, exclusions: seq[Component] = @[]): Size =
  var size = procCall self.DefaultLayout.calcAutoSize(exclusions)
  # Add image dimensions
  return size

method createLayout*(self: Image): Layout =
  return ImageLayout(component: self)

# Behaviours
type
  ImageResourceBehaviour* = ref object of DataBehaviour

method validateData*(self: ImageResourceBehaviour) =
  let component = self.component
  # Image loading logic
  discard

# Builder
type
  ImageBuilder* = ref object of CompositeBuilder

method createBuilder*(self: Image): CompositeBuilder =
  return ImageBuilder(component: self)
