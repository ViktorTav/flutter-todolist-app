import 'package:flutter/material.dart';

class Config {
  static final colorScheme = ColorScheme.fromSeed(seedColor: Colors.lightBlue);
  static const defaultPageContentPadding =
      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0);
  static const savedTasksPath = "tasks.json";

  static final themeData = ThemeData(
      colorScheme: colorScheme,
      snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
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

  static const notification = {
    "channel": {
      "id": "0",
      "name": "Padrão",
      "description": "Notificações padrão do aplicativo",
    },
    "icon": {"drawableResource": "app_icon", "color": Colors.white},
  };
}
