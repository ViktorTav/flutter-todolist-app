import 'package:flutter/material.dart';
import 'package:widget/src/provider/app.dart';
import 'package:widget/src/views/widgets/form/input.dart';

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleInputController = TextEditingController();
  final _contentInputController = TextEditingController();

  void _handleSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    AppState.of(context).addTodo(
        title: _titleInputController.text,
        content: _contentInputController.text);

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
              child: const Text("Criar"))
        ],
      ),
    );
  }
}
