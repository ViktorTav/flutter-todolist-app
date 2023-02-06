import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:widget/src/models/local_notification.dart';

//ignore_for_file: unused_element

class NotificationAction extends AndroidNotificationAction {
  NotificationAction._(
    super.id,
    super.title, {
    super.titleColor,
    super.icon,
    super.contextual = false,
    super.showsUserInterface = false,
    super.allowGeneratedReplies = false,
    super.inputs = const <AndroidNotificationActionInput>[],
    super.cancelNotification = true,
  });

  factory NotificationAction(
      {required ActionId id,
      required String title,
      required bool showsUserInterface}) {
    return NotificationAction._(id.toString(), title,
        showsUserInterface: showsUserInterface);
  }
}
