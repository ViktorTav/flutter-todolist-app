import 'package:widget/src/models/local_notification.dart';

class ScheduledNotification extends LocalNotification {
  final DateTime date;

  ScheduledNotification(
      {required super.title,
      required super.content,
      required super.payload,
      required this.date});
}
