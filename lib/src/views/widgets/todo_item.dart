import 'package:flutter/material.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/provider/app.dart';
import 'package:widget/src/views/edit_task.dart';
import 'package:widget/src/views/task_details.dart';
import 'package:widget/src/views/widgets/snackbars/task.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoItem todoItem;

  const TodoItemWidget({super.key, required this.todoItem});

  void _handleOnTap(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskDetailsView(todoItem: todoItem)));
  }

  void _handleChangeTaskStatus(BuildContext context) {
    final SnackBar snackBar;

    if (todoItem.completed) {
      snackBar = TaskStackBar.createTodo(todoItem: todoItem, context: context);
    } else {
      snackBar =
          TaskStackBar.createFinished(todoItem: todoItem, context: context);
    }
    AppState.of(context).toggleTaskStatus(todoItem: todoItem);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  void _handleDeletePopupItemTap(BuildContext context) {
    AppState.of(context).deleteTodo(todoItem: todoItem);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
          TaskStackBar.createDeleted(todoItem: todoItem, context: context));
  }

  void _handleEditPopupItemTap(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditTaskView(todoItem: todoItem)));
  }

  @override
  Widget build(BuildContext context) {
    var checkedIcon = todoItem.completed
        ? Icons.check_box
        : Icons.check_box_outline_blank_outlined;

    return Column(
      children: [
        ListTile(
          onTap: () => _handleOnTap(context),
          leading: IconButton(
            icon: Icon(checkedIcon,
                color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () => _handleChangeTaskStatus(context),
          ),
          trailing: PopupMenuButton<Function>(
            icon: Icon(Icons.more_vert,
                color: Theme.of(context).colorScheme.onPrimary),
            initialValue: () => null,
            onSelected: (Function f) => f(),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Function>>[
              PopupMenuItem<Function>(
                value: () => _handleEditPopupItemTap(context),
                child: const Text("Editar"),
              ),
              PopupMenuItem<Function>(
                value: () => _handleDeletePopupItemTap(context),
                child: Text(
                  "Excluir",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          title: Text(
            todoItem.title,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          tileColor: Theme.of(context).colorScheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.all(8.0),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
