import 'package:flutter/material.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/provider/app.dart';

class TaskStackBar {
  static SnackBar createDeleted(
      {required TodoItem todoItem, required BuildContext context}) {
    final undoLastTaskRemoval = AppState.of(context).undoLastTaskRemoval;

    return SnackBar(
      content: const Text("Tarefa excluída com sucesso!"),
      action: SnackBarAction(
        //TODO: Colocar a cor da label no Theme
        textColor: Colors.white,
        label: "Desfazer",
        onPressed: () => undoLastTaskRemoval(),
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
    final toggleTaskStatus = AppState.of(context).toggleTaskStatus;

    return SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(text),
        action: SnackBarAction(
            label: "Desfazer",
            textColor: Colors.white,
            onPressed: () {
              toggleTaskStatus(todoItem: todoItem);
            }));
  }
}
