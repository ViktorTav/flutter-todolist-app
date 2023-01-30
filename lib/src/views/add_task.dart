import 'package:flutter/material.dart';
import 'package:widget/config.dart';
import 'package:widget/src/views/widgets/add_task_form.dart';

class AddTaskView extends StatelessWidget {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar tarefa:"),
      ),
      body: const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: Config.defaultPageContentPadding,
          child: AddTaskForm(),
        ),
      ),
    );
  }
}
