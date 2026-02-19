import nimui/events/ui_event
import nimui/util/variant

type
  NotificationEvent* = ref object of UIEvent
    # notification*: Notification
    # actionData*: NotificationActionData

proc newNotificationEvent*(typ: string): NotificationEvent =
  new result
  result.init(typ)
