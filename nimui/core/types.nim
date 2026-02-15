import nimui/validation/ivalidating
import nimui/util/color
import nimui/backend/component_surface
import nimui/backend/image_surface
import nimui/backend/event_impl
import std/options

type
  Style* = ref object of RootObj
    backgroundColor*: Option[Color]
    backgroundColorEnd*: Option[Color]
    backgroundGradientStyle*: Option[string]
    backgroundOpacity*: Option[float]
    borderColor*: Option[Color]
    borderTopColor*: Option[Color]
    borderLeftColor*: Option[Color]
    borderBottomColor*: Option[Color]
    borderRightColor*: Option[Color]
    borderSize*: Option[float]
    borderTopSize*: Option[float]
    borderLeftSize*: Option[float]
    borderBottomSize*: Option[float]
    borderRightSize*: Option[float]
    borderRadius*: Option[float]
    borderRadiusTopLeft*: Option[float]
    borderRadiusTopRight*: Option[float]
    borderRadiusBottomLeft*: Option[float]
    borderRadiusBottomRight*: Option[float]
    borderOpacity*: Option[float]
    borderStyle*: Option[string]
    color*: Option[Color]
    cursor*: Option[string]
    hidden*: Option[bool]
    left*: Option[float]
    top*: Option[float]
    width*: Option[float]
    height*: Option[float]
    percentWidth*: Option[float]
    percentHeight*: Option[float]
    minWidth*: Option[float]
    minHeight*: Option[float]
    maxWidth*: Option[float]
    maxHeight*: Option[float]
    paddingTop*: Option[float]
    paddingLeft*: Option[float]
    paddingRight*: Option[float]
    paddingBottom*: Option[float]
    marginTop*: Option[float]
    marginLeft*: Option[float]
    marginRight*: Option[float]
    marginBottom*: Option[float]
    horizontalAlign*: Option[string]
    verticalAlign*: Option[string]
    textAlign*: Option[string]
    fontName*: Option[string]
    fontSize*: Option[float]
    horizontalSpacing*: Option[float]
    verticalSpacing*: Option[float]

  Layout* = ref object of RootObj
    componentInternal*: Component

  Component* = ref object of IValidating
    idInternal*: string
    depthInternal*: int
    parentComponent*: Component
    childComponents*: seq[Component]
    surface*: ComponentSurface
    imageSurface*: ImageSurface
    styleInternal*: Style
    layoutInternal*: Layout
    behavioursInternal*: RootRef # To avoid circular with Behaviours

    # Position and Size
    leftInternal*: float
    topInternal*: float
    widthInternal*: float
    heightInternal*: float

    # Percent Size
    percentWidthInternal*: Option[float]
    percentHeightInternal*: Option[float]

    # Auto size
    autoWidth*: bool
    autoHeight*: bool

    # Include in layout
    includeInLayout*: bool

    # Validation flags
    isAllInvalidInternal*: bool
    isLayoutInvalidInternal*: bool
    isDisplayInvalidInternal*: bool
    isStyleInvalidInternal*: bool
    isPositionInvalidInternal*: bool
    isComponentShipInvalidInternal*: bool
    isReadyInternal*: bool

  UIEvent* = ref object of EventImpl
    `type`*: string
    target*: Component
    bubble*: bool
    data*: RootRef
    canceled*: bool
    relatedEvent*: UIEvent
    relatedComponent*: Component
