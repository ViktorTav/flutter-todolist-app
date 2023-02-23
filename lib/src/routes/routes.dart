import 'package:flutter/material.dart';
import 'package:widget/src/animations/page_transition.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/views/app_router.dart';
import 'package:widget/src/views/finished_tasks.dart';
import 'package:widget/src/views/loading.dart';
import 'package:widget/src/views/task_details.dart';
import 'package:widget/src/views/todo_tasks.dart';

final routes = {
  "/": ([Object? arguments]) => const AppRouter(),
  "/todo": ([Object? arguments]) => const TodoTasksView(),
  "/finished": ([Object? arguments]) => const FinishedTasksView(),
  "/loading": ([Object? arguments]) => const LoadingView(),
  "/taskDetails": (Object? argument) => TaskDetailsView(
        todoItem: argument! as TodoItem,
      )
};

class Routes {
  static Route<dynamic> handleOnGenerateRoute(RouteSettings settings) {
    return PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) =>
            routes[settings.name]!(settings.arguments)));
  }

  static void changeRoute(BuildContext context, Widget child) {
    Navigator.of(context)
      ..pop()
      ..push(MaterialPageRoute(builder: (context) => child));
  }

  static void changeRouteWithTransition(BuildContext context, Widget child) {
    Navigator.of(context)
        .push(PageRouteBuilder(
            reverseTransitionDuration: const Duration(microseconds: 0),
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: ((context, animation, secondaryAnimation) =>
                pageTransition(context, animation, secondaryAnimation, child))))
        .then((value) => Navigator.pop(context));
  }
}
