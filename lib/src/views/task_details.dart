import 'package:flutter/material.dart';
import 'package:widget/config.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/util/date.dart';
import 'package:widget/src/views/widgets/field.dart';

class TaskDetailsView extends StatelessWidget {
  final TodoItem todoItem;

  const TaskDetailsView({super.key, required this.todoItem});

  List<Field> _buildFields() {
    return [
      Field(
          label: "Título:", content: todoItem.title, icon: Icons.info_outline),
      Field(
          label: "Conteúdo:",
          content: todoItem.content,
          icon: Icons.description_outlined),
      Field(
          label: "Criado em:",
          content: convertToLocalDate(todoItem.createdAtTime.toLocal()),
          icon: Icons.calendar_month),
    ];
  }

  Future<void> handleLeadingAppBarIconButtonTap(BuildContext context) async {
    final navigator = Navigator.of(context);

    if (!(await navigator.maybePop())) {
      print("alo");
      navigator.popAndPushNamed("/todo");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => handleLeadingAppBarIconButtonTap(context),
        ),
        title: const Text("Detalhes da tarefa:"),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: Config.defaultPageContentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildFields(),
          ),
        ),
      ),
    );
  }
}
