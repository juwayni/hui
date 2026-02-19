import nimui/util/event_dispatcher
import nimui/notifications/notification
import nimui/notifications/notification_data
import nimui/core/types
import nimui/util/timer
import std/options

type
  NotificationManager* = ref object of EventDispatcher
    currentNotifications: seq[Notification]
    maxNotifications*: int
    notificationDisplayDelayMs*: int

var notificationManagerInstance: NotificationManager

proc instance*(): NotificationManager =
  if notificationManagerInstance == nil:
    new notificationManagerInstance
    notificationManagerInstance.initEventDispatcher()
    notificationManagerInstance.currentNotifications = @[]
    notificationManagerInstance.maxNotifications = -1
    notificationManagerInstance.notificationDisplayDelayMs = 50
  return notificationManagerInstance

proc addNotification*(self: NotificationManager, data: NotificationData): Notification =
  let n = newNotification()
  n.data = data
  self.currentNotifications.add(n)
  # Logic to show notification
  return n

proc removeNotification*(self: NotificationManager, n: Notification) =
  let idx = self.currentNotifications.find(n)
  if idx != -1:
    self.currentNotifications.delete(idx)
    # Logic to hide notification
