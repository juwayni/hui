import nimui/core/component
import nimui/core/types
import nimui/components/checkbox
import nimui/behaviours/data_behaviour
import nimui/core/composite_builder
import nimui/util/variant
import std/tables

type
  OptionBox* = ref object of CheckBox
    componentGroupInternal*: string

proc newOptionBox*(): OptionBox =
  new result
  result.initComponent()

# Behaviours
type
  OptionBoxGroupBehaviour* = ref object of DataBehaviour
  OptionBoxSelectedBehaviour* = ref object of DataBehaviour

# Builder
type
  OptionBoxBuilder* = ref object of CheckBoxBuilder

method createBuilder*(self: OptionBox): CompositeBuilder =
  return OptionBoxBuilder(component: self)

# Groups
type
  OptionBoxGroups* = ref object of RootObj
    groups: Table[string, seq[OptionBox]]

var optionBoxGroupsInstance: OptionBoxGroups = nil

proc optionBoxGroups*(): OptionBoxGroups =
  if optionBoxGroupsInstance == nil:
    new optionBoxGroupsInstance
    optionBoxGroupsInstance.groups = initTable[string, seq[OptionBox]]
  return optionBoxGroupsInstance
