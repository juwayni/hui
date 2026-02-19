import ../core/types

type
  IValidator* = ref object of RootObj
    invalidMessage*: string

method setup*(self: IValidator, component: Component) {.base.} = discard
method validate*(self: IValidator, component: Component): Option[bool] {.base.} = return some(true)
method setProperty*(self: IValidator, name: string, value: Variant) {.base.} = discard
