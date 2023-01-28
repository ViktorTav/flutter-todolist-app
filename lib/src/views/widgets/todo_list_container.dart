import 'package:flutter/material.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/views/widgets/todo_item.dart';

class TodoListContainer extends StatelessWidget {
  final List<TodoItem> list;

  const TodoListContainer({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => TodoItemWidget(todoItem: list[index]),
      ),
    );
  }
}
