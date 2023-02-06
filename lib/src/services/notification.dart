import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:widget/config.dart';
import 'package:widget/src/models/local_notification.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:widget/src/models/scheduled_notification.dart';
import 'package:widget/src/util/date.dart';

abstract class NotificationServiceException implements Exception {
  String get message;
}

//TODO: trocar isso por um assertion
class NotificationServiceNotInitialized
    implements NotificationServiceException {
  @override
  final String message =
      "[NotificationService] Failed to display a notification. Did you forget to initialize the class?";
}

class NotificationService {
  static final _localNotification = FlutterLocalNotificationsPlugin();
  static late final NotificationDetails _defaultNotificationDetails;
  static late final Function(NotificationResponse)
      _didReceiveNotificationResponse;
  static bool _initialized = false;

  static Future<void> initialize(
      {required Function(NotificationResponse notificationResponse)
          didReceiveNotificationResponse}) async {
    //Inicialização do plugin de notificações

    _didReceiveNotificationResponse = didReceiveNotificationResponse;

    final initializationSettingsAndroid = AndroidInitializationSettings(
        Config.notification["icon"]!["drawableResource"] as String);

    final initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotification.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _handleDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            _handleDidReceiveNotificationResponse);

    final androidNotificationDetails = AndroidNotificationDetails(
      Config.notification["channel"]!["id"] as String,
      Config.notification["channel"]!["name"] as String,
      channelDescription:
          Config.notification["channel"]!["description"] as String,
      importance: Importance.max,
      priority: Priority.high,
      color: Config.notification["icon"]!["color"] as Color,
    );

    _defaultNotificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    //Inicialização do timezone para notificações agendendas

    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    _initialized = true;
  }

  static Future<NotificationAppLaunchDetails?>
      getNotificationAppLaunchDetails() {
    return _localNotification.getNotificationAppLaunchDetails();
  }

  static Future<void> displayNotification(
      LocalNotification notification) async {
    assert(_initialized);

    await _localNotification.show(notification.id, notification.title,
        notification.content, _defaultNotificationDetails,
        payload: notification.payload);
  }

  static Future<void> scheduleNotification(
      ScheduledNotification notification) async {
    assert(_initialized);

    final defaultAndroidNotificationDetails =
        _defaultNotificationDetails.android!;

    final androidNotificationDetails = AndroidNotificationDetails(
        defaultAndroidNotificationDetails.channelId,
        defaultAndroidNotificationDetails.channelName,
        channelDescription:
            defaultAndroidNotificationDetails.channelDescription,
        importance: defaultAndroidNotificationDetails.importance,
        priority: defaultAndroidNotificationDetails.priority,
        color: defaultAndroidNotificationDetails.color,
        actions: notification.actions);

    final notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    _localNotification.zonedSchedule(
        notification.id,
        notification.title,
        notification.content,
        tz.TZDateTime.fromMicrosecondsSinceEpoch(
            tz.local, notification.date.microsecondsSinceEpoch),
        notificationDetails,
        payload: notification.payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: false);
  }

  //TODO: cancelScheduledNotification
  static Future<void> cancelScheduledNotification(int id) async {
    assert(_initialized);
  }

  //TODO: editScheduledNotification
  static Future<void> editScheduledNotification(int id) async {
    assert(_initialized);
  }

  static void _handleDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    _didReceiveNotificationResponse(notificationResponse);
  }
}
