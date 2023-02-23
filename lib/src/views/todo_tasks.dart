import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/models/todo_list.dart';
import 'package:widget/src/views/widgets/app_drawer.dart';
import 'package:widget/src/views/widgets/snackbars/task.dart';
import 'package:widget/src/views/widgets/todo_list_container.dart';
import 'package:widget/src/views/widgets/floating_add_task.dart';

class TodoTasksView extends StatelessWidget {
  const TodoTasksView({super.key});

  void _handleDeleteAllItemTap(BuildContext context) {
    final todoList = Provider.of<TodoList>(context, listen: false);
    final Function removeLastDeletedList = todoList.removeLastDeletedList;

    todoList.removeAllUnfinishedTasks();

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

    final List<TodoItem> list = todoList.unfinishedList;

    final body =
        list.isEmpty ? const _NoTasks() : TodoListContainer(list: list);

    return Scaffold(
      extendBodyBehindAppBar: list.isEmpty,
      appBar: AppBar(
        title: const Text("A fazer"),
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
      drawer: const AppDrawer(selectedItem: 0),
      floatingActionButton: const FloatingAddTask(),
    );
  }
}

class _NoTasks extends StatelessWidget {
  const _NoTasks();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.done_rounded, size: 200.0),
          Text(
            "Sem tarefas",
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "Que tal adicionar uma nova clicando no botão '+' abaixo?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    ));
  }
}
