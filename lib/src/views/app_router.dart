import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:widget/src/provider/app.dart';
import 'package:widget/src/routes/router.dart';
import 'package:widget/src/routes/routes.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        AppState.of(context).notificationAppLaunchDetails;

    bool? tasksObtained = AppState.of(context).tasksObtained;

    if (notificationAppLaunchDetails == null || tasksObtained == null) {
      return routes["/loading"]!;
    } else if (notificationAppLaunchDetails.didNotificationLaunchApp == false) {
      return routes["/todo"]!;
    }

    return CustomRouter.getRouteFromNotificationResponse(
        context: context,
        notificationResponse:
            notificationAppLaunchDetails.notificationResponse!);
  }
}
