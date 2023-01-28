import 'package:flutter/material.dart';
import 'package:widget/src/provider/app.dart';
import 'package:widget/src/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      child: MaterialApp(
          title: "TodoList",
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue)),
          initialRoute: "/todo",
          onGenerateRoute: handleOnGenerateRoute),
    );
  }
}
