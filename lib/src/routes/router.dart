import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/provider/app.dart';
import 'package:widget/src/routes/routes.dart';
import 'package:widget/src/views/task_details.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        AppState.of(context).notificationAppLaunchDetails;

    bool? tasksObtained = AppState.of(context).tasksObtained;

    print("$notificationAppLaunchDetails $tasksObtained");

    if (notificationAppLaunchDetails == null || tasksObtained == null) {
      return routes["/loading"]!;
    } else if (notificationAppLaunchDetails.didNotificationLaunchApp == false) {
      return routes["/todo"]!;
    }

    final String todoItemId =
        notificationAppLaunchDetails.notificationResponse!.payload!;

    final TodoItem? todoItem =
        AppState.of(context).list.getItem(id: todoItemId);

    print(todoItemId);

    if (todoItem == null) {
      debugPrint("No existe um todo no");
      return routes["/todo"]!;
    }

    return TaskDetailsView(todoItem: todoItem);
  }
}
