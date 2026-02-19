import macros
import nimui/macros/helpers/class_builder
import nimui/macros/helpers/code_builder
import nimui/macros/helpers/code_pos

macro haxeui_build_event*(typeSection: untyped): untyped =
  # Similar to buildEvent in Haxe
  result = typeSection

macro haxeui_build*(typeSection: untyped): untyped =
  # Similar to build in Haxe
  result = typeSection

macro haxeui_build_behaviours*(typeSection: untyped): untyped =
  # Generates property getters/setters for behaviours
  result = typeSection

macro haxeui_build_data*(typeSection: untyped): untyped =
  # Similar to buildData in Haxe
  result = typeSection
