import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:widget/src/data/task_data.dart';
import 'package:widget/src/models/deleted_todo_item.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:collection/collection.dart';

class TodoList extends ChangeNotifier with WidgetsBindingObserver {
  final _unfinishedList = <TodoItem>[];
  final _finishedList = <TodoItem>[];
  DeletedTodoItem? _lastDeletedItem;

  /*
    Quando todos os items de uma lista são excluídos através do botão "excluir todos", 
    adicionamos a lista excluída aqui para caso seja necessário restaurar depois.

    Caso o usuário não restaure depois da exibição do snackbar, excluímos a lista definitivamente. 
  */
  final _deletedLists = <List<TodoItem>>[];

  bool? _initialized;

  TodoList() {
    initialize();
  }

  bool? get initialized => _initialized;
  List<TodoItem> get fullList => [..._unfinishedList, ..._finishedList];
  List<TodoItem> get finishedList => _finishedList;
  List<TodoItem> get unfinishedList => _unfinishedList;

  void initialize() {
    try {
      TaskData.getTasksFromFile().then((taskListMap) {
        for (var taskMap in taskListMap) {
          final TodoItem item = TodoItem.createFromJson(json: taskMap);

          if (taskMap["completed"]) {
            _finishedList.add(item);
          } else {
            _unfinishedList.add(item);
          }
        }

        _initialized = true;
        notifyListeners();
      });
    } on Exception catch (e, s) {
      _initialized = false;
      notifyListeners();

      debugPrint("[TodoList] Failed to get tasks from json. $e");
      debugPrint("$s");
    }

    //Adicionamos a instância como observador para verificamos mudanças no ciclo de vida do aplicativo
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void addAll({required List<TodoItem> list}) {
    for (var item in list) {
      addItem(todoItem: item);
    }

    notifyListeners();
  }

  void addFinishedItem({required TodoItem todoItem}) {
    if (_finishedList.contains(todoItem)) return;

    _finishedList.add(todoItem);

    notifyListeners();
  }

  void addItem({required TodoItem todoItem}) {
    if (_unfinishedList.contains(todoItem)) return;

    _unfinishedList.add(todoItem);

    notifyListeners();
  }

  void editTodo(
      {required TodoItem originalItem, required TodoItem editedItem}) {
    if (!originalItem.checkChanges(editedItem)) return;

    originalItem
      ..title = editedItem.title
      ..content = editedItem.content;

    notifyListeners();
  }

  void toggleItemStatus({required TodoItem todoItem}) {
    if (todoItem.completed) {
      _finishedList.remove(todoItem);
      _unfinishedList.add(todoItem);
    } else {
      _unfinishedList.remove(todoItem);
      _finishedList.add(todoItem);
    }

    todoItem.completed = !todoItem.completed;

    notifyListeners();
  }

  TodoItem? getItem({required String id}) {
    return fullList.firstWhereOrNull((element) => element.id == id);
  }

  void undoLastItemRemoval() {
    if (_lastDeletedItem == null) {
      debugPrint(
          "[TodoList] Failed to undo last item removal. There's no deleted item");
      return;
    }

    if (_lastDeletedItem!.todoItem.completed) {
      _finishedList.insert(_lastDeletedItem!.index, _lastDeletedItem!.todoItem);
    } else {
      _unfinishedList.insert(
          _lastDeletedItem!.index, _lastDeletedItem!.todoItem);
    }

    _lastDeletedItem = null;

    notifyListeners();
  }

  void undoLastListRemoval() {
    if (_deletedLists.isEmpty) {
      debugPrint(
          "[TodoList] Failed to undo last list removal. There are no deleted lists.");
    }

    if (_deletedLists[0][0].completed) {
      _finishedList.addAll(_deletedLists[0]);
    } else {
      _unfinishedList.addAll(_deletedLists[0]);
    }

    _deletedLists.removeAt(0);

    notifyListeners();
  }

  bool removeItem({required TodoItem todoItem, required int index}) {
    final list = todoItem.completed ? _finishedList : _unfinishedList;

    if (!list.remove(todoItem)) {
      debugPrint(
          "[TodoList] There isn't a task called \"${todoItem.title}\" in the list.");

      return false;
    }

    /*
      Ao salvarmos o último item excluído é possível readicionar uma tarefa caso o usuário 
      exclua ela sem querer.
    */

    _lastDeletedItem = DeletedTodoItem(todoItem: todoItem, index: index);

    notifyListeners();

    return true;
  }

  bool removeItemById({required String id}) {
    TodoItem? item;
    int? index;

    for (int i = 0; i < fullList.length; i++) {
      if (fullList[i].id == id) {
        item = fullList[i];
        index = i;

        break;
      }
    }

    if (item == null || index == null) {
      debugPrint("[TodoList] There isn't a task with id \"$id\" in the list.");
      return false;
    }

    removeItem(todoItem: item, index: index);

    notifyListeners();

    return true;
  }

  void removeAllFinishedTasks() {
    if (_finishedList.isEmpty) {
      debugPrint(
          "[TodoList] Failed to remove all finished tasks. There are no items on the list.");

      return;
    }

    _deletedLists.add([..._finishedList]);
    _finishedList.removeRange(0, _finishedList.length);

    notifyListeners();
  }

  void removeAllUnfinishedTasks() {
    if (_unfinishedList.isEmpty) {
      debugPrint(
          "[TodoList] Failed to remove all unfinished tasks. There are no items on the list.");
      return;
    }

    _deletedLists.add([..._unfinishedList]);
    _unfinishedList.removeRange(0, _unfinishedList.length);

    notifyListeners();
  }

  void removeLastDeletedList() {
    if (_deletedLists.isEmpty) {
      debugPrint(
          "[TodoList] Failed to remove the last deleted list. There are no deleted lists");
      return;
    }

    _deletedLists.removeAt(0);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      try {
        await TaskData.saveTasks(list: this);
      } catch (e, s) {
        debugPrint("[TodoList] Failed to saveTasks. $e");
        debugPrint("$s");
      }
    }
  }

  String toJson() {
    return jsonEncode(fullList.map((e) => e.toJson()).toList());
  }
}
