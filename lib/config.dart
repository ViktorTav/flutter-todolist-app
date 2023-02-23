import 'package:flutter/material.dart';
import 'package:widget/src/models/local_notification.dart';
import 'package:widget/src/models/notification_action.dart';

class Config {
  static final colorScheme = ColorScheme.fromSeed(seedColor: Colors.lightBlue);
  static const defaultPageContentPadding =
      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0);
  static const savedTasksPath = "tasks.json";

  static final themeData = ThemeData(
      colorScheme: colorScheme,
      snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
          errorMaxLines: 5,
          filled: true,
          fillColor: Colors.grey[200],
          enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.grey[200]!)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: colorScheme.primary)),
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: colorScheme.error)),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)));

  static final fieldTheme = {
    "titleColor": Colors.black,
    "contentColor": Colors.grey[200]
  };

  static final notification = {
    "channel": {
      "id": "0",
      "key": "default",
      "name": "Padrão",
      "description": "Notificações padrão do aplicativo",
    },
    "icon": {
      "drawableResource": "notification_icon",
      "color": colorScheme.primary
    },
    "task": {
      "actions": [
        NotificationAction(
          key: ActionKey.finishTask,
          title: "Concluir",
        ),
        NotificationAction(
          key: ActionKey.taskDetails,
          title: "Detalhes",
        )
      ]
    }
  };
}
