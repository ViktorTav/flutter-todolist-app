import 'dart:ffi';

import 'package:awesome_notifications/awesome_notifications.dart';

enum ActionKey { taskDetails, finishTask }

class NotificationAction extends NotificationActionButton {
  NotificationAction({
    required ActionKey key,
    required String title,
    super.icon,
    super.enabled,
    super.requireInputText,
    super.autoDismissible,
    super.showInCompactView,
    super.isDangerousOption,
    super.color,
    super.actionType,
  }) : super(key: key.index.toString(), label: title);
}
