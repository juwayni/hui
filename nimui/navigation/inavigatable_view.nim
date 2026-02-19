import nimui/util/variant
import std/tables

type
  INavigatableView* = concept x
    x.applyParams(params: Table[string, Variant])
