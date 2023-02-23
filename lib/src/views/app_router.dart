import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget/src/provider/state.dart';
import 'package:widget/src/routes/router.dart';
import 'package:widget/src/routes/routes.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (appState.appLaunchedByNotification == null ||
        appState.tasksObtained == null) {
      return routes["/loading"]!();
    } else if (appState.appLaunchedByNotification == false) {
      return routes["/todo"]!();
    }

    return CustomRouter.getRouteFromNotification(
        receivedAction: appState.initialNotificationAction);
  }
}
