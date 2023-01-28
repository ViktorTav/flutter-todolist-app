import 'package:flutter/material.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/provider/app.dart';

class TaskStackBar {
  static SnackBar createFinished(
      {required TodoItem todoItem, required BuildContext context}) {
    return _create(
        todoItem: todoItem,
        context: context,
        text: "Tarefa movida para aba \"Finalizados\"");
  }

  static SnackBar createTodo(
      {required TodoItem todoItem, required BuildContext context}) {
    return _create(
        todoItem: todoItem,
        context: context,
        text: "Tarefa movida para aba \"A fazer\"");
  }

  static SnackBar _create(
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