import 'package:flutter/material.dart';
import 'package:widget/src/provider/app.dart';
import 'package:widget/src/routes/routes.dart';
import 'package:widget/src/views/todo_tasks.dart';
import 'package:widget/src/views/widgets/app_drawer.dart';
import 'package:widget/src/views/widgets/todo_list_container.dart';

class FinishedTasksView extends StatelessWidget {
  const FinishedTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final list = AppState.of(context).list.getFinishedList();

    final body =
        list.isEmpty ? const _NoFinishedTasks() : TodoListContainer(list: list);

    return Scaffold(
      extendBodyBehindAppBar: list.isEmpty,
      appBar: AppBar(
        title: const Text("Finalizadas:"),
      ),
      body: body,
      drawer: const AppDrawer(selectedItem: 1),
    );
  }
}

class _NoFinishedTasks extends StatelessWidget {
  const _NoFinishedTasks();

  void _handleElevatedButtonGoTap(BuildContext context) {
    Routes.changeRoute(context, const TodoTasksView());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction_rounded, size: 200.0),
          Text(
            "Sem tarefas concluídas",
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "Conclua uma apertando o botão ao lado do nome da tarefa na aba \"A fazer\".",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
                color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => _handleElevatedButtonGoTap(context),
            style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Theme.of(context).colorScheme.primary),
            child: const Text("Ir", style: TextStyle(fontSize: 15)),
          )
        ],
      ),
    ));
  }
}
