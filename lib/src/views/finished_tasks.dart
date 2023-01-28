import 'package:flutter/material.dart';
import 'package:widget/src/provider/app.dart';
import 'package:widget/src/views/widgets/app_drawer.dart';
import 'package:widget/src/views/widgets/todo_list_container.dart';

class FinishedTasksView extends StatelessWidget {
  const FinishedTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finalizadas:"),
      ),
      body:
          TodoListContainer(list: AppState.of(context).list.getFinishedList()),
      drawer: const AppDrawer(selectedItem: 1),
    );
  }
}
