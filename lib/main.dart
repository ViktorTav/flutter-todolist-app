import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget/config.dart';
import 'package:widget/src/models/todo_list.dart';
import 'package:widget/src/provider/state.dart';
import 'package:widget/src/routes/routes.dart';
import 'package:widget/src/services/notification.dart';

Future<void> main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => TodoList()),
      ChangeNotifierProvider(create: (context) => NotificationService()),
      ChangeNotifierProxyProvider2<TodoList, NotificationService, AppState>(
          create: (context) => AppState(),
          update: (_, list, notificationService, appState) =>
              appState!.update(notificationService, list)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: MyApp.navigatorKey,
        title: "TodoList",
        theme: Config.themeData,
        initialRoute: "/",
        onGenerateRoute: Routes.handleOnGenerateRoute);
  }
}
