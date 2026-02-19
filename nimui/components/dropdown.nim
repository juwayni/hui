import nimui/core/component
import nimui/core/types
import nimui/components/button
import nimui/data/data_source
import nimui/behaviours/data_behaviour
import nimui/behaviours/default_behaviour
import nimui/behaviours/dynamic_data_behaviour
import nimui/events/ui_event
import nimui/util/variant
import std/options

type
  DropDown* = ref object of Button
    handlerStyleNames*: string
    dataSourceInternal*: DataSource[Variant]
    typeInternal*: string
    virtualInternal*: bool
    selectedIndexInternal*: int
    selectedItemInternal*: Variant

proc newDropDown*(): DropDown =
  new result
  result.initComponent()

# Handlers
type
  IDropDownHandler* = ref object of RootObj
    component*: Component

  DropDownHandler* = ref object of IDropDownHandler

# Behaviours
type
  DropDownDataSourceBehaviour* = ref object of DefaultBehaviour
  DropDownSelectedIndexBehaviour* = ref object of DataBehaviour
  DropDownSelectedItemBehaviour* = ref object of DynamicDataBehaviour

# Builder
type
  DropDownBuilder* = ref object of ButtonBuilder

method createBuilder*(self: DropDown): CompositeBuilder =
  return DropDownBuilder(component: self)
