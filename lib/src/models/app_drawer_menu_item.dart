import 'package:flutter/widgets.dart';

class AppDrawerMenuItem {
  final String title;
  final IconData icon;
  final void Function(BuildContext context) onTap;

  const AppDrawerMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
