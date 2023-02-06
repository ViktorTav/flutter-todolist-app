import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:widget/src/data/task_data.dart';
import 'package:widget/src/data/todo_list.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/services/notification.dart';
import 'package:widget/src/routes/routes.dart';
import 'package:widget/src/routes/router.dart';

class AppProvider extends StatefulWidget {
  final Widget child;

  const AppProvider({super.key, required this.child});

  @override
  AppProviderState createState() => AppProviderState();
}

class AppProviderState extends State<AppProvider> with WidgetsBindingObserver {
  final list = TodoList();
  NotificationAppLaunchDetails? notificationAppLaunchDetails;
  bool? tasksObtained;

  @override
  void initState() {
    try {
      TaskData.getTasksFromFile().then((taskListMap) {
        for (var taskMap in taskListMap) {
          if (taskMap["completed"]) {
            list.addFinishedItem(
                todoItem: TodoItem.createFromJson(json: taskMap));
          } else {
            list.addItem(todoItem: TodoItem.createFromJson(json: taskMap));
          }
        }

        setState(() {
          list;
          tasksObtained = true;
        });
      });
    } catch (e, s) {
      tasksObtained = false;

      debugPrint("[AppProvider] Failed to get tasks from json. $e");
      debugPrint("$s");
    }

    NotificationService.initialize(
            didReceiveNotificationResponse:
                _handleDidReceiveNotificationResponse)
        .then((value) {
      NotificationService.getNotificationAppLaunchDetails().then((value) {
        setState(() {
          notificationAppLaunchDetails = value;
        });
      });
    });

    //Adicionamos a instância como observador para verificamos mudanças no ciclo de vida do aplicativo
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _undoLastTaskRemoval() {
    setState(() {
      list.undoLastItemRemoval();
    });
  }

  void _toggleTaskStatus({required TodoItem todoItem}) {
    setState(() {
      list.toggleItemStatus(todoItem: todoItem);
    });
  }

  void _deleteTodo({required TodoItem todoItem}) {
    setState(() {
      list.removeItem(todoItem: todoItem);
    });
  }

  void _addTodo({required TodoItem todoItem}) {
    setState(() {
      list.addItem(todoItem: todoItem);
    });
  }

  void _editTodo(
      {required TodoItem originalItem, required TodoItem editedItem}) {
    if (!originalItem.checkChanges(editedItem)) return;

    setState(() {
      originalItem
        ..title = editedItem.title
        ..content = editedItem.content;
    });
  }

  void _removeAllUnfinishedTasks() {
    //TODO: Colocar um snackbar para recuperar as tarefas excluídas.

    setState(() {
      list.removeAllUnfinishedTasks();
    });
  }

  Future<void> _saveTasks() async {
    try {
      await TaskData.saveTasks(list: list);
    } catch (e, s) {
      debugPrint("[AppState] Failed to saveTasks. $e");
      debugPrint("$s");
    }
  }

  void _handleDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    Routes.changeRoute(
        context,
        CustomRouter.getRouteFromNotificationResponse(
            context: context, notificationResponse: notificationResponse));
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint("AppLifeCycle state changed");

    /*
      Caso o aplicativo esteja em segundo plano, tentamos salvar a lista de tarefas atual em um json.
    */
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      await _saveTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppState(
        list: list,
        toggleTaskStatus: _toggleTaskStatus,
        deleteTodo: _deleteTodo,
        addTodo: _addTodo,
        saveTasks: _saveTasks,
        editTodo: _editTodo,
        undoLastTaskRemoval: _undoLastTaskRemoval,
        notificationAppLaunchDetails: notificationAppLaunchDetails,
        tasksObtained: tasksObtained,
        removeAllUnfinishedTasks: _removeAllUnfinishedTasks,
        child: widget.child);
  }
}

class AppState extends InheritedWidget {
  final TodoList list;
  final void Function({required TodoItem todoItem}) toggleTaskStatus,
      deleteTodo;
  final void Function({required TodoItem todoItem}) addTodo;
  final void Function(
      {required TodoItem originalItem, required TodoItem editedItem}) editTodo;

  final void Function() undoLastTaskRemoval, removeAllUnfinishedTasks;
  final Future<void> Function() saveTasks;
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  final bool? tasksObtained;

  const AppState(
      {super.key,
      required super.child,
      required this.list,
      required this.toggleTaskStatus,
      required this.deleteTodo,
      required this.addTodo,
      required this.saveTasks,
      required this.editTodo,
      required this.undoLastTaskRemoval,
      required this.notificationAppLaunchDetails,
      required this.tasksObtained,
      required this.removeAllUnfinishedTasks});

  @override
  bool updateShouldNotify(covariant AppState oldWidget) {
    return oldWidget.list == list;
  }

  static AppState? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppState>();
  }

  static AppState of(BuildContext context) {
    var result = maybeOf(context);
    assert(result != null, "No TodoListProvider found in context");
    return result!;
  }
}
