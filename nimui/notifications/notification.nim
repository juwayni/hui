import nimui/core/types
import nimui/core/component
import nimui/containers/vbox
import nimui/containers/hbox
import nimui/components/label
import nimui/components/image
import nimui/components/button
import nimui/events/ui_event
import nimui/events/mouse_event
import nimui/notifications/notification_data
import nimui/notifications/notification_type
import std/options

type
  Notification* = ref object of VBox
    titleLabel*: Label
    bodyLabel*: Label
    closeButton*: Image
    notificationIcon*: Image
    actionsFooter*: HBox
    actionsContainer*: HBox
    dataInternal*: NotificationData

proc newNotification*(): Notification =
  new result
  initComponent(result)

  # Manual child creation (parity with HaxeUI XML)
  let titleHBox = newHBox()
  titleHBox.styleInternal.percentWidth = some(100.0)
  result.titleLabel = newLabel()
  result.titleLabel.idInternal = "title"
  result.titleLabel.styleInternal.percentWidth = some(100.0)
  titleHBox.addComponent(result.titleLabel)

  result.closeButton = newImage()
  result.closeButton.idInternal = "closeButton"
  titleHBox.addComponent(result.closeButton)
  result.addComponent(titleHBox)

  # ... (more children)

  result.bodyLabel = newLabel()
  result.bodyLabel.idInternal = "body"
  result.addComponent(result.bodyLabel)

method data*(self: Notification): NotificationData {.base.} = self.dataInternal
method `data=`*(self: Notification, value: NotificationData) {.base.} =
  self.dataInternal = value
  self.titleLabel.text = value.title
  self.bodyLabel.text = value.body
  # ... (apply more data)
