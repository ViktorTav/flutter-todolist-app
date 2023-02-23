import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/models/todo_list.dart';
import 'package:widget/src/routes/routes.dart';
import 'package:widget/src/views/todo_tasks.dart';
import 'package:widget/src/views/widgets/app_drawer.dart';
import 'package:widget/src/views/widgets/snackbars/task.dart';
import 'package:widget/src/views/widgets/todo_list_container.dart';

class FinishedTasksView extends StatelessWidget {
  const FinishedTasksView({super.key});

  void _handleDeleteAllItemTap(BuildContext context) {
    final todoList = Provider.of<TodoList>(context, listen: false);
    final Function removeLastDeletedList = todoList.removeLastDeletedList;

    todoList.removeAllFinishedTasks();

    /*
      Mostramos uma snackbar para caso o usuário deseje restaurar a lista excluída. 
    */
    ScaffoldMessenger.of(context)
        .showSnackBar(TaskSnackBar.createDeletedAll(context))
        .closed
        .then((SnackBarClosedReason reason) {
      /* 
        Removemos definitivamente a lista caso o usuário não restaurou a lista através da
        action da snackbar.
      */
      if (reason == SnackBarClosedReason.action) return;
      removeLastDeletedList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoList = context.watch<TodoList>();

    final List<TodoItem> list = todoList.finishedList;

    final body =
        list.isEmpty ? const _NoFinishedTasks() : TodoListContainer(list: list);

    return Scaffold(
      extendBodyBehindAppBar: list.isEmpty,
      appBar: AppBar(
        title: const Text("Finalizadas:"),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => <PopupMenuItem>[
                    PopupMenuItem(
                      onTap: () => _handleDeleteAllItemTap(context),
                      child: const Text("Excluir todos"),
                    )
                  ])
        ],
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
