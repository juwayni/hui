import nimui/core/component
import nimui/core/types
import nimui/core/interactive_component
import nimui/core/composite_builder
import nimui/layouts/default_layout
import nimui/behaviours/data_behaviour
import nimui/behaviours/default_behaviour
import nimui/util/variant
import std/options

type
  TextField* = ref object of InteractiveComponent
    passwordInternal*: bool
    maxCharsInternal*: int
    restrictCharsInternal*: string
    placeholderInternal*: string

proc newTextField*(): TextField =
  new result
  result.initComponent()

# Layout
type
  TextFieldLayout* = ref object of DefaultLayout

method resizeChildren*(self: TextFieldLayout) =
  procCall self.DefaultLayout.resizeChildren()
  discard

method repositionChildren*(self: TextFieldLayout) =
  procCall self.DefaultLayout.repositionChildren()
  discard

method createLayout*(self: TextField): Layout =
  return TextFieldLayout(component: self)

# Behaviours
type
  TextFieldTextBehaviour* = ref object of DataBehaviour
  TextFieldPasswordBehaviour* = ref object of DataBehaviour

# Builder
type
  TextFieldBuilder* = ref object of CompositeBuilder

method createBuilder*(self: TextField): CompositeBuilder =
  return TextFieldBuilder(component: self)
