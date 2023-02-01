import 'package:uuid/uuid.dart';
import 'package:widget/src/types/json.dart';

class TodoItem {
  String id, title, content;
  bool completed;
  DateTime? scheduledNotificationTime;
  int? scheduledNotificationId;

  final DateTime createdAtTime, taskDate;

  TodoItem(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAtTime,
      required this.completed,
      required this.taskDate,
      this.scheduledNotificationId,
      this.scheduledNotificationTime});

  factory TodoItem.createFromJson({required Json json}) {
    return TodoItem(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        createdAtTime:
            DateTime.fromMillisecondsSinceEpoch(json["createdAtTime"]),
        completed: json["completed"],
        scheduledNotificationTime: json["scheduledNotificationTime"] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                json["scheduledNotificationTime"])
            : null,
        scheduledNotificationId: json["scheduledNotificationId"],
        taskDate: DateTime.fromMillisecondsSinceEpoch(json["taskDate"]));
  }

  factory TodoItem.create(
      {required String title,
      required String content,
      required DateTime taskDate,
      DateTime? scheduledNotificationTime,
      int? scheduledNotificationId,
      String? id,
      DateTime? createdAtTime,
      bool? completed}) {
    return TodoItem(
        id: id ?? const Uuid().v1(),
        title: title,
        content: content,
        createdAtTime: createdAtTime ?? DateTime.now(),
        completed: completed ?? false,
        scheduledNotificationTime: scheduledNotificationTime,
        scheduledNotificationId: scheduledNotificationId,
        taskDate: taskDate);
  }

  bool checkChanges(TodoItem editedItem) {
    return !(editedItem.content == content && editedItem.title == title);
  }

  Json toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "createdAtTime": createdAtTime.millisecondsSinceEpoch,
      "completed": completed,
      "scheduledNotificationTime":
          scheduledNotificationTime?.millisecondsSinceEpoch,
      "taskDate": taskDate.millisecondsSinceEpoch,
      "scheduledNotificationId": scheduledNotificationId,
    };
  }

  @override
  bool operator ==(covariant TodoItem other) {
    return other.completed == completed &&
        other.content == content &&
        other.title == title &&
        other.createdAtTime == other.createdAtTime;
  }

  @override
  int get hashCode => Object.hash(createdAtTime.microsecondsSinceEpoch, id);
}
