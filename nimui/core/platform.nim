import ../backend/platform_impl

type
  Platform* = ref object of PlatformImpl

const METRIC_VSCROLL_WIDTH* = "platform.metrics.vscroll.width"
const METRIC_HSCROLL_HEIGHT* = "platform.metrics.hscroll.height"

var gInstance: Platform

proc instance*(): Platform =
  if gInstance == nil:
    gInstance = Platform()
  return gInstance

proc vscrollWidth*(): float =
  return instance().getMetric(METRIC_VSCROLL_WIDTH)

proc hscrollHeight*(): float =
  return instance().getMetric(METRIC_HSCROLL_HEIGHT)

method getMetric*(self: Platform, id: string): float =
  procCall getMetric(PlatformImpl(self), id)
