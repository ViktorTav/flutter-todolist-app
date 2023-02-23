import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/models/todo_list.dart';
import 'package:widget/src/views/widgets/form/input.dart';

class EditTaskForm extends StatefulWidget {
  final TodoItem todoItem;

  const EditTaskForm({super.key, required this.todoItem});

  @override
  State<EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<EditTaskForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleInputController = TextEditingController();
  final _contentInputController = TextEditingController();

  @override
  void initState() {
    _titleInputController.text = widget.todoItem.title;
    _contentInputController.text = widget.todoItem.content;

    super.initState();
  }

  void _handleSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    //TODO: Colocar a opção de alterar a data de entrega na edição
    final editedTask = TodoItem.create(
        taskDate: DateTime.now(),
        title: _titleInputController.text,
        content: _contentInputController.text);

    Provider.of<TodoList>(context, listen: false)
        .editTodo(originalItem: widget.todoItem, editedItem: editedTask);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    final inputControllers = <TextEditingController>[
      _titleInputController,
      _contentInputController
    ];

    for (var controller in inputControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormInput(
            controller: _titleInputController,
            fieldName: "Título",
            labelText: "Título",
            autoFocus: true,
            required: true,
          ),
          FormInput(
            controller: _contentInputController,
            fieldName: "Conteúdo",
            labelText: "Conteúdo",
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50.0)),
              onPressed: () => _handleSubmit(context),
              child: const Text("Salvar"))
        ],
      ),
    );
  }
}
