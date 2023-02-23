import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:widget/config.dart';
import 'package:widget/main.dart';
import 'package:widget/src/models/local_notification.dart';

import 'package:widget/src/models/scheduled_notification.dart';
import 'package:widget/src/routes/router.dart';

abstract class NotificationServiceException implements Exception {
  String get message;
}

class NotificationService extends ChangeNotifier {
  bool _initialized = false;
  final _awesomeNotifications = AwesomeNotifications();
  ReceivedAction? _initialNotificationAction;
  bool? _appLaunchedByNotification;

  ReceivedAction? get initialNotificationAction => _initialNotificationAction;
  bool? get appLaunchedByNotification => _appLaunchedByNotification;

  NotificationService() {
    initialize();
    getInitialNotificationAction();
  }

  Future<void> initialize() async {
    await _awesomeNotifications.initialize(
        "resource://drawable/${Config.notification["icon"]!["drawableResource"]}",
        [
          NotificationChannel(
              channelKey: Config.notification["channel"]!["key"] as String,
              channelName: Config.notification["channel"]!["name"] as String,
              channelDescription:
                  Config.notification["channel"]!["description"] as String,
              defaultColor: Config.notification["icon"]!["color"] as Color,
              importance: NotificationImportance.High)
        ]);

    await _awesomeNotifications.setListeners(
        onActionReceivedMethod: onActionReceivedMethod);

    _initialized = true;
  }

  Future<void> getInitialNotificationAction() async {
    if (appLaunchedByNotification != null) return;

    _initialNotificationAction =
        await _awesomeNotifications.getInitialNotificationAction();

    _appLaunchedByNotification = _initialNotificationAction != null;

    notifyListeners();
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction action) async {
    MyApp.navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) =>
            CustomRouter.getRouteFromNotification(receivedAction: action)));
  }

  Future<void> displayNotification(LocalNotification notification) async {
    assert(_initialized);

    await _awesomeNotifications.createNotification(
      content: NotificationContent(
          id: notification.id,
          channelKey: Config.notification["channel"]!["key"] as String,
          title: notification.title,
          body: notification.content,
          actionType: ActionType.Default),
    );
  }

  Future<void> scheduleNotification(ScheduledNotification notification) async {
    assert(_initialized);

    await _awesomeNotifications.createNotification(
        content: NotificationContent(
            id: notification.id,
            channelKey: Config.notification["channel"]!["key"] as String,
            title: notification.title,
            body: notification.content,
            actionType: ActionType.Default,
            payload: notification.payload),
        actionButtons: notification.actions,
        schedule: NotificationCalendar.fromDate(date: notification.date));
  }

  //TODO: cancelScheduledNotification
  Future<void> cancelScheduledNotification(int id) async {
    assert(_initialized);
  }

  //TODO: editScheduledNotification
  Future<void> editScheduledNotification(int id) async {
    assert(_initialized);
  }
}
