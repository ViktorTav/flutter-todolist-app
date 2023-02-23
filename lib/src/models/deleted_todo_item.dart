import 'package:widget/src/models/todo_item.dart';

class DeletedTodoItem {
  final TodoItem todoItem;
  final int index;

  DeletedTodoItem({required this.todoItem, required this.index});
}
