import 'package:uuid/uuid.dart';
import 'package:widget/src/types/json.dart';

class TodoItem {
  String id, title, content;
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

  bool checkChanges(TodoItem editedItem) {
    return !(editedItem.content == content && editedItem.title == title);
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
  bool operator ==(covariant TodoItem other) {
    return other.completed == completed &&
        other.content == content &&
        other.title == title &&
        other.createdAtTime == other.createdAtTime;
  }

  @override
  int get hashCode => Object.hash(createdAtTime.microsecondsSinceEpoch, id);
}
