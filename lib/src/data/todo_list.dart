import 'dart:convert';

import 'package:widget/src/models/todo_item.dart';

class ItemNoExists implements Exception {}

class TodoList {
  final _unfinishedList = <TodoItem>[];
  final _finishedList = <TodoItem>[];

  TodoList();

  List<TodoItem> get fullList => [..._unfinishedList, ..._finishedList];

  void addAll({required List<TodoItem> list}) {
    for (var item in list) {
      addItem(todoItem: item);
    }
  }

  void addFinishedItem({required TodoItem todoItem}) {
    if (_finishedList.contains(todoItem)) return;

    _finishedList.add(todoItem);
  }

  void addItem({required TodoItem todoItem}) {
    if (_unfinishedList.contains(todoItem)) return;

    _unfinishedList.add(todoItem);
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
  }

  TodoItem? getItem({required String id}) {
    for (var item in fullList) {
      if (item.id == id) {
        return item;
      }
    }

    return null;
  }

  void removeItem({required TodoItem todoItem}) {
    final list = todoItem.completed ? _finishedList : _unfinishedList;

    if (!list.remove(todoItem)) {
      throw ItemNoExists();
    }
  }

  void removeItemById({required String id}) {
    var item = getItem(id: id);

    if (item == null) {
      throw ItemNoExists();
    }

    removeItem(todoItem: item);
  }

  List<TodoItem> getFinishedList() {
    return _finishedList;
  }

  List<TodoItem> getUnFinishedList() {
    return _unfinishedList;
  }

  String toJson() {
    return jsonEncode(fullList.map((e) => e.toJson()).toList());
  }

  @override
  bool operator ==(covariant TodoList other) {
    if (other.fullList.length != fullList.length) return false;

    var otherList = other.fullList;
    for (int i = 0; i < fullList.length; i++) {
      if (fullList[i] != otherList[i]) return false;
    }

    return true;
  }

  @override
  int get hashCode => Object.hash(fullList, fullList.length);
}
