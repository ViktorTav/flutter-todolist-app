import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:widget/src/models/todo_list.dart';
import 'package:widget/src/services/notification.dart';

class AppState extends ChangeNotifier {
  bool? tasksObtained, appLaunchedByNotification;
  ReceivedAction? initialNotificationAction;

  AppState update(NotificationService notificationService, TodoList list) {
    if (notificationService.appLaunchedByNotification !=
            appLaunchedByNotification &&
        list.initialized != tasksObtained) {
      appLaunchedByNotification = notificationService.appLaunchedByNotification;
      initialNotificationAction = notificationService.initialNotificationAction;
      tasksObtained = list.initialized;

      notifyListeners();
    }

    return this;
  }
}
