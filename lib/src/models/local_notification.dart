import 'package:widget/src/models/notification_action.dart';

enum ActionId { taskDetails, finishTask }

class LocalNotification {
  static int _ids = 0;

  final int id = _ids++;
  final String title, content, payload;
  final List<NotificationAction>? actions;

  LocalNotification(
      {required this.content,
      required this.title,
      required this.payload,
      this.actions});
}
