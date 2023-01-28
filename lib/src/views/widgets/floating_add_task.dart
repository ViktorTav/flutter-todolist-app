import 'package:flutter/material.dart';
import 'package:widget/src/views/add_task.dart';

class FloatingAddTask extends StatelessWidget {
  const FloatingAddTask({super.key});

  void _handleOnPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AddTaskView()));
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        tooltip: "Add task",
        onPressed: () => _handleOnPressed(context),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSecondary,
        ));
  }
}
