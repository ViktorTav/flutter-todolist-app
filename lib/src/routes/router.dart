import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget/main.dart';
import 'package:widget/src/models/notification_action.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/models/todo_list.dart';
import 'package:widget/src/routes/routes.dart';
import 'package:widget/src/views/widgets/snackbars/task.dart';

abstract class CustomRouter {
  static Widget getRouteFromNotification(
      {required ReceivedAction? receivedAction}) {
    if (receivedAction != null) {
      final BuildContext context = MyApp.navigatorKey.currentContext!;

      final String taskId = receivedAction.payload!["taskId"]!;

      final todoList = context.read<TodoList>();

      final TodoItem? todoItem = todoList.getItem(id: taskId);

      //TODO: Criar uma página para uma tarefa que não existe.
      if (todoItem != null) {
        final ActionKey actionKey =
            ActionKey.values[int.parse(receivedAction.buttonKeyPressed)];

        if (actionKey == ActionKey.taskDetails) {
          return routes["/taskDetails"]!(todoItem);
        }

        if (actionKey == ActionKey.finishTask) {
          final toggleTaskStatus = todoList.toggleItemStatus;

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            toggleTaskStatus(todoItem: todoItem);

            ScaffoldMessenger.of(context).showSnackBar(
                TaskSnackBar.createTodo(todoItem: todoItem, context: context));
          });
        }
      }
    }

    return routes["/todo"]!();
  }
}
