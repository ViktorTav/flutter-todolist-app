import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:widget/src/models/local_notification.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/provider/app.dart';
import 'package:widget/src/routes/routes.dart';
import 'package:widget/src/views/task_details.dart';

abstract class CustomRouter {
  static Widget getRouteFromNotificationResponse(
      {required BuildContext context,
      required NotificationResponse notificationResponse}) {
    final String todoItemId = notificationResponse.payload!;

    final TodoItem? todoItem =
        AppState.of(context).list.getItem(id: todoItemId);

    //TODO: Criar uma página para uma tarefa que não existe.
    if (todoItem == null) {
      debugPrint("No existe um todo no");
      return routes["/todo"]!;
    }

    final actionId = notificationResponse.actionId;

    print(actionId);

    if (actionId != null) {
      if (actionId == ActionId.taskDetails.toString()) {
        return TaskDetailsView(todoItem: todoItem);
      } else if (actionId == ActionId.finishTask.toString()) {
        final toggleTaskStatus = AppState.of(context).toggleTaskStatus;

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          toggleTaskStatus(todoItem: todoItem);
        });
      }
    }

    return routes["/todo"]!;
  }
}
