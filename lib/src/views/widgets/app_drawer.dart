import 'package:flutter/material.dart';
import 'package:widget/src/models/app_drawer_menu_item.dart';

class AppDrawer extends StatelessWidget {
  final int selectedItem;

  const AppDrawer({super.key, required this.selectedItem});

  void _handleOnTapTodo(BuildContext context) {
    _changeRoute(context, "/todo");
  }

  void _handleOnTapCompleted(BuildContext context) {
    _changeRoute(context, "/finished");
  }

  void _changeRoute(BuildContext context, String routeName) {
    final navigator = Navigator.of(context);

    /*
      Para uma transição mais suave entre as mudanças de rotas, esperamos a animação de saída 
      do drawer acabar para mudar a rota.
    */
    navigator.pop(context);

    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      navigator.popAndPushNamed(routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.primary),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Todolist",
                    style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
            AppDrawerMenuList(
              selectedItem: selectedItem,
              children: [
                AppDrawerMenuItem(
                  title: "A fazer",
                  icon: Icons.list_rounded,
                  onTap: _handleOnTapTodo,
                ),
                AppDrawerMenuItem(
                    title: "Finalizadas",
                    icon: Icons.task_alt_rounded,
                    onTap: _handleOnTapCompleted)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppDrawerMenuList extends StatelessWidget {
  final List<AppDrawerMenuItem> children;
  final int selectedItem;

  const AppDrawerMenuList(
      {super.key, required this.children, required this.selectedItem});

  List<Widget> _buildAppDrawerMenuItems() {
    final list = <_AppDrawerMenuItem>[];

    for (var i = 0; i < children.length; i++) {
      list.add(_AppDrawerMenuItem(
          title: children[i].title,
          icon: children[i].icon,
          onTap: (BuildContext context) {
            debugPrint("Selected");
            if (i == selectedItem) return;

            children[i].onTap(context);
          },
          selected: selectedItem == i));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(children: _buildAppDrawerMenuItems()),
    );
  }
}

class _AppDrawerMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function(BuildContext context) onTap;
  final bool selected;

  const _AppDrawerMenuItem(
      {required this.title,
      required this.icon,
      required this.onTap,
      this.selected = false});

  @override
  Widget build(BuildContext context) {
    final textColor = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: textColor),
          textColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          selected: selected,
          selectedTileColor:
              Theme.of(context).colorScheme.primary.withAlpha(50),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          title: Text(title),
          onTap: () => onTap(context),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
