import 'package:flutter/material.dart';
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
          //TODO: Colocar o padding padrão da página em um arquivo de configuração
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: EditTaskForm(todoItem: todoItem),
        ),
      ),
    );
  }
}
