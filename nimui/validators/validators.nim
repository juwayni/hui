import nimui/core/types
import nimui/util/variant
import std/options
import std/re

type
  IValidator* = concept x
    x.invalidMessage is string
    x.setup(component: Component)
    x.validate(component: Component): Option[bool]
    x.setProperty(name: string, value: Variant)

  Validator* = ref object of RootObj
    invalidMessage*: string
    applyValid*: bool
    applyInvalid*: bool
    validStyleName*: string
    invalidStyleName*: string

proc initValidator*(self: Validator) =
  self.applyValid = true
  self.applyInvalid = true
  self.validStyleName = "valid-value"
  self.invalidStyleName = "invalid-value"

method setup*(self: Validator, component: Component) {.base.} = discard
method validate*(self: Validator, component: Component): Option[bool] {.base.} =
  # Porting logic from HaxeUI validateInternal
  return none(bool)

method setProperty*(self: Validator, name: string, value: Variant) {.base.} =
  case name:
  of "applyValid": self.applyValid = value.toBool()
  of "applyInvalid": self.applyInvalid = value.toBool()
  of "invalidMessage": self.invalidMessage = value.toString()
  else: discard

type
  PatternValidator* = ref object of Validator
    pattern*: Regex

method validateString(self: PatternValidator, s: string): Option[bool] {.base.} =
  if s == "": return none(bool)
  return some(s.contains(self.pattern))

type
  EmailValidator* = ref object of PatternValidator

proc newEmailValidator*(): EmailValidator =
  new result
  result.initValidator()
  result.invalidMessage = "Invalid email address"
  result.pattern = re"^[^\-@\s:&!\/\\]+([\.-]?[^@\s:&!\/\\]+)*@[^\-@\s:&!\/\\\.]+([\.-]?[^@\s:&!\/\\\.]+)*(\.[^\-@\s:&!\/\\\.]{2,})+$"

type
  RequiredValidator* = ref object of Validator

proc newRequiredValidator*(): RequiredValidator =
  new result
  result.initValidator()
  result.invalidMessage = "Required field"
  result.invalidStyleName = "required-value"

method setup*(self: RequiredValidator, component: Component) =
  component.addClass("required")

method validate*(self: RequiredValidator, component: Component): Option[bool] =
  let s = component.getProperty("text").toString()
  return some(s.len > 0)
