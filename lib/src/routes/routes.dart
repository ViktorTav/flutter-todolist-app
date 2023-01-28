import 'package:flutter/widgets.dart';
import 'package:widget/src/views/finished_tasks.dart';
import 'package:widget/src/views/todo_tasks.dart';

final routes = {
  "/": const Placeholder(),
  "/todo": const TodoTasksView(),
  "/finished": const FinishedTasksView()
};

Route<dynamic> handleOnGenerateRoute(RouteSettings settings) {
  debugPrint(settings.name);

  return PageRouteBuilder(
      pageBuilder: ((context, animation, secondaryAnimation) =>
          routes[settings.name]!));
}
