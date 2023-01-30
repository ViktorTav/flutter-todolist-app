import 'package:flutter/material.dart';
import 'package:widget/config.dart';
import 'package:widget/src/provider/app.dart';
import 'package:widget/src/routes/routes.dart';

Future<void> main() async {
  runApp(const AppProvider(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
        title: "TodoList",
        theme: Config.themeData,
        initialRoute: "/",
        onGenerateRoute: Routes.handleOnGenerateRoute));
  }
}
