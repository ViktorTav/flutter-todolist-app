import 'package:flutter/material.dart';
import 'package:widget/src/animations/page_transition.dart';
import 'package:widget/src/provider/app.dart';
import 'package:widget/src/routes/router.dart';
import 'package:widget/src/views/finished_tasks.dart';
import 'package:widget/src/views/loading.dart';
import 'package:widget/src/views/todo_tasks.dart';

final routes = {
  "/": const AppRouter(),
  "/todo": const TodoTasksView(),
  "/finished": const FinishedTasksView(),
  "/loading": const LoadingView()
};

class Routes {
  static Route<dynamic> handleOnGenerateRoute(RouteSettings settings) {
    print(settings.name);

    return PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) =>
            routes[settings.name]!));
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
