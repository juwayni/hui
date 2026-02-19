import nimui/validation/ivalidating
import nimui/util/color
import nimui/backend/component_surface
import nimui/backend/image_surface
import nimui/backend/event_impl
import std/options
import nimui/util/variant
import std/tables

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
    opacity*: Option[float]
    backgroundImage*: Option[string]
    horizontalSpacing*: Option[float]
    verticalSpacing*: Option[float]
    initialWidth*: Option[float]
    initialHeight*: Option[float]
    initialPercentWidth*: Option[float]
    initialPercentHeight*: Option[float]
    animationName*: Option[string]
    animationOptionsInternal*: RootRef # AnimationOptions
    pointerEvents*: Option[string]
    native*: Option[bool]
    includeInLayout*: Option[bool]
    customDirectives*: RootRef # TableRef[string, string]
    wordWrap*: Option[bool]

  Layout* = ref object of RootObj
    component*: Component

  Component* = ref object of IValidating
    idInternal*: string
    depthInternal*: int
    parentComponent*: Component
    childComponents*: seq[Component]
    surface*: ComponentSurface
    imageSurface*: ImageSurface
    styleInternal*: Style
    customStyleInternal*: Style
    layoutInternal*: Layout
    behavioursInternal*: RootRef # Behaviours
    eventsInternal*: RootRef # To avoid circular with EventMap

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
    isDataInvalidInternal*: bool
    isComponentShipInvalidInternal*: bool
    isReadyInternal*: bool

    # Classes and States
    classesInternal*: seq[string]

    # Extra fields for 100% parity
    componentTabIndex*: int
    nativeInternal*: Option[bool]
    animatableInternal*: bool
    componentAnimationInternal*: RootRef # Avoid circular with Animation
    userData*: Variant
    allowDispose*: bool
    isDisposedInternal*: bool
    disabledInternal*: bool
    focusInternal*: bool
    allowFocusInternal*: bool
    autoFocusInternal*: bool
    initialSizeAppliedInternal*: bool
    recursivePointerEventsInternal*: bool
    pauseAnimationStyleChangesInternal*: bool
    compositeBuilderInternal*: RootRef
    componentClipRectInternal*: RootRef # Rectangle

  AnimationBuilder* = ref object of RootObj
    target*: Component
    onComplete*: proc() {.gcsafe.}
    duration*: float
    easing*: string

  UIEvent* = ref object of EventImpl
    `type`*: string
    target*: Component
    bubble*: bool
    data*: Variant
    canceled*: bool
    relatedEvent*: UIEvent
    relatedComponent*: Component

  # Behaviours Hierarchy in types to break cycles
  Behaviour* = ref object of RootObj
    config*: Table[string, string]
    component*: Component
    id*: string

  ValueBehaviour* = ref object of Behaviour
    previousValueInternal*: Variant
    valueInternal*: Variant

  DataBehaviour* = ref object of ValueBehaviour
    dataInvalidInternal*: bool

  DefaultBehaviour* = ref object of Behaviour
    valueInternal*: Variant

  DynamicBehaviour* = ref object of Behaviour
    dynamicValueInternal*: Variant

  DynamicDataBehaviour* = ref object of DynamicBehaviour
    dataInvalidInternal*: bool

  InvalidatingBehaviour* = ref object of ValueBehaviour

  LayoutBehaviour* = ref object of ValueBehaviour

  # Added for 100% parity
  InteractiveComponent* = ref object of Component
    actionRepeatInterval*: int
    validatorsInternal*: RootRef # Validators

  Box* = ref object of Component
    hasDataSourceInternal*: bool
    itemRendererInternal*: ItemRenderer
    layoutNameInternal*: string
    cacheItemRenderersInternal*: bool

  ItemRenderer* = ref object of Box
    autoRegisterInteractiveEvents*: bool
    recursiveStyling*: bool
    allowLayoutProperties*: bool
    maxRecursionLevel*: int
    dataInternal*: Variant
    itemIndex*: int

# Common Methods
method validate*(self: Behaviour) {.base, gcsafe.} = discard
method validateData*(self: DataBehaviour) {.base, gcsafe.} = discard
method update*(self: Behaviour) {.base, gcsafe.} = discard
method set*(self: Behaviour, value: Variant) {.base, gcsafe.} = discard
method get*(self: Behaviour): Variant {.base, gcsafe.} = return toVariant(nil)
method call*(self: Behaviour, param: Variant = toVariant(nil)): Variant {.base, gcsafe.} = return toVariant(nil)
