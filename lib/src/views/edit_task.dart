import 'package:flutter/material.dart';
import 'package:widget/config.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/views/widgets/edit_task_form.dart';

class EditTaskView extends StatelessWidget {
  final TodoItem todoItem;

  const EditTaskView({super.key, required this.todoItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar tarefa:"),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: Config.defaultPageContentPadding,
          child: EditTaskForm(todoItem: todoItem),
        ),
      ),
    );
  }
}
