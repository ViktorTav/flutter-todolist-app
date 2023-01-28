import 'package:flutter/widgets.dart';

SlideTransition pageTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondAnimation,
    Widget child) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;

  const curve = Curves.easeIn;

  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}
