import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/models/todo_list.dart';

abstract class TaskSnackBar {
  static SnackBar createDeletedAll(BuildContext context) {
    final undoLastListRemoval =
        Provider.of<TodoList>(context, listen: false).undoLastListRemoval;

    return SnackBar(
      content: const Text("Todas as tarefas excluídas com sucesso!"),
      action: SnackBarAction(
        textColor: Theme.of(context).snackBarTheme.actionTextColor,
        label: "Desfazer",
        onPressed: undoLastListRemoval,
      ),
    );
  }

  static SnackBar createDeleted(
      {required TodoItem todoItem, required BuildContext context}) {
    final undoLastItemRemoval =
        Provider.of<TodoList>(context, listen: false).undoLastItemRemoval;

    return SnackBar(
      content: const Text("Tarefa excluída com sucesso!"),
      action: SnackBarAction(
        textColor: Theme.of(context).snackBarTheme.actionTextColor,
        label: "Desfazer",
        onPressed: undoLastItemRemoval,
      ),
    );
  }

  static SnackBar createFinished(
      {required TodoItem todoItem, required BuildContext context}) {
    return _createToggleTaskStatusSnackbar(
        todoItem: todoItem,
        context: context,
        text: "Tarefa movida para aba \"Finalizados\"");
  }

  static SnackBar createTodo(
      {required TodoItem todoItem, required BuildContext context}) {
    return _createToggleTaskStatusSnackbar(
        todoItem: todoItem,
        context: context,
        text: "Tarefa movida para aba \"A fazer\"");
  }

  static SnackBar _createToggleTaskStatusSnackbar(
      {required TodoItem todoItem,
      required BuildContext context,
      required String text}) {
    /* 
      Não é possível executar essa função (toggleCompleted) diretamente dentro do OnPressed por conta que
      após a tarefa ser mudada de lista, provavelmente o contexto do ListTile que usamos aqui não é mais 
      válido, não sendo mais possível acessar o AppState. 
    */
    final toggleTaskStatus =
        Provider.of<TodoList>(context, listen: false).toggleItemStatus;

    return SnackBar(
        content: Text(text),
        action: SnackBarAction(
            label: "Desfazer",
            textColor: Colors.white,
            onPressed: () {
              toggleTaskStatus(todoItem: todoItem);
            }));
  }
}
