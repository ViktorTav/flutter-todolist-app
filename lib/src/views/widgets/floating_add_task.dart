import 'package:flutter/material.dart';
import 'package:widget/src/models/scheduled_notification.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/services/notification.dart';
import 'package:widget/src/views/add_task.dart';

class FloatingAddTask extends StatelessWidget {
  const FloatingAddTask({super.key});

  void _handleOnPressed(BuildContext context) {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => const AddTaskView()));

    NotificationService.scheduleNotification(ScheduledNotification(
        title: "title",
        content: "content",
        payload: "dasklsadjkl",
        date: DateTime.now().add(Duration(seconds: 1))));
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        tooltip: "Add task",
        onPressed: () => _handleOnPressed(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ));
  }
}
