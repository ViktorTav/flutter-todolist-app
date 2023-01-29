import 'package:flutter/widgets.dart';
import 'package:widget/src/data/task_data.dart';
import 'package:widget/src/data/todo_list.dart';
import 'package:widget/src/models/todo_item.dart';

class AppProvider extends StatefulWidget {
  final Widget child;

  const AppProvider({super.key, required this.child});

  @override
  AppProviderState createState() => AppProviderState();
}

class AppProviderState extends State<AppProvider> with WidgetsBindingObserver {
  final list = TodoList();

  @override
  void initState() {
    try {
      TaskData.getTasksFromFile().then((taskListMap) {
        debugPrint("$taskListMap");
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
        });
      });
    } catch (e, s) {
      debugPrint("[AppProvider] Failed to get tasks from json. $e");
      debugPrint("$s");
    }

    //Adicionamos a instância como observador para verificamos mudanças no ciclo de vida do aplicativo
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void undoLastTaskRemoval() {
    setState(() {
      list.undoLastItemRemoval();
    });
  }

  void toggleTaskStatus({required TodoItem todoItem}) {
    setState(() {
      list.toggleItemStatus(todoItem: todoItem);
    });
  }

  void deleteTodo({required TodoItem todoItem}) {
    setState(() {
      list.removeItem(todoItem: todoItem);
    });
  }

  void addTodo({required String title, required String content}) {
    setState(() {
      list.addItem(todoItem: TodoItem.create(title: title, content: content));
    });
  }

  void editTodo(
      {required TodoItem originalItem, required TodoItem editedItem}) {
    if (!originalItem.checkChanges(editedItem)) return;

    setState(() {
      originalItem
        ..title = editedItem.title
        ..content = editedItem.content;
    });
  }

  Future<void> saveTasks() async {
    try {
      await TaskData.saveTasks(list: list);
    } catch (e, s) {
      debugPrint("[AppState] Failed to saveTasks. $e");
      debugPrint("$s");
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint("AppLifeCycle state changed");

    /*
      Caso o aplicativo esteja em segundo plano, tentamos salvar a lista de tarefas atual em um json.
    */
    if (state == AppLifecycleState.paused) {
      await saveTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppState(
        list: list,
        toggleTaskStatus: toggleTaskStatus,
        deleteTodo: deleteTodo,
        addTodo: addTodo,
        saveTasks: saveTasks,
        editTodo: editTodo,
        undoLastTaskRemoval: undoLastTaskRemoval,
        child: widget.child);
  }
}

class AppState extends InheritedWidget {
  final TodoList list;
  final void Function({required TodoItem todoItem}) toggleTaskStatus,
      deleteTodo;
  final void Function({required String title, required String content}) addTodo;
  final void Function(
      {required TodoItem originalItem, required TodoItem editedItem}) editTodo;

  final void Function() undoLastTaskRemoval;
  final Future<void> Function() saveTasks;

  const AppState(
      {super.key,
      required super.child,
      required this.list,
      required this.toggleTaskStatus,
      required this.deleteTodo,
      required this.addTodo,
      required this.saveTasks,
      required this.editTodo,
      required this.undoLastTaskRemoval});

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
