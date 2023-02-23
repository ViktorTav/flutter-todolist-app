import 'package:widget/src/models/notification_action.dart';

class LocalNotification {
  static int _ids = 0;

  final int id = _ids++;
  final String title, content;
  final Map<String, String> payload;
  final List<NotificationAction>? actions;

  LocalNotification(
      {required this.content,
      required this.title,
      required this.payload,
      this.actions});
}
