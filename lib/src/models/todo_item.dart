import 'package:uuid/uuid.dart';
import 'package:widget/src/types/json.dart';

class TodoItem {
  final String id, title, content;
  final DateTime createdAtTime;
  bool completed;

  TodoItem(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAtTime,
      required this.completed});

  factory TodoItem.createFromJson({required Json json}) {
    return TodoItem(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        createdAtTime:
            DateTime.fromMillisecondsSinceEpoch(json["createdAtTime"]),
        completed: json["completed"]);
  }

  factory TodoItem.create(
      {required String title,
      required String content,
      String? id,
      DateTime? createdAtTime,
      bool? completed}) {
    return TodoItem(
        id: id ?? const Uuid().v1(),
        title: title,
        content: content,
        createdAtTime: createdAtTime ?? DateTime.now(),
        completed: completed ?? false);
  }

  Json toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "createdAtTime": createdAtTime.millisecondsSinceEpoch,
      "completed": completed
    };
  }

  @override
  bool operator ==(covariant TodoItem other) => other.id == id;

  @override
  int get hashCode => Object.hash(createdAtTime.microsecondsSinceEpoch, id);
}
