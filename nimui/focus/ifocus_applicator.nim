import nimui/core/types

type
  IFocusApplicator* = concept x
    x.apply(target: Component)
    x.unapply(target: Component)
    x.enabled is bool
