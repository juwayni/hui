import nimui/util/variant
import nimui/notifications/notification_type

type
  NotificationActionData* = ref object
    text*: string
    icon*: Variant
    callback*: proc(data: NotificationActionData): bool {.gcsafe.}

  NotificationData* = ref object
    body*: string
    title*: string
    icon*: string
    actions*: seq[NotificationActionData]
    expiryMs*: int
    typ*: NotificationType
    styleNames*: string

proc newNotificationData*(body: string): NotificationData =
  new result
  result.body = body
  result.actions = @[]
  result.expiryMs = -1
  result.typ = ntDefault
