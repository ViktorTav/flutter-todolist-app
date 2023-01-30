import 'package:flutter/material.dart';

class FormTextArea extends StatefulWidget {
  final String fieldName, labelText;
  final bool autoFocus, required;
  final TextEditingController? controller;
  final String? Function(String? value)? customValidator;
  final int maxLines;

  const FormTextArea(
      {super.key,
      required this.fieldName,
      required this.labelText,
      this.maxLines = 5,
      this.controller,
      this.customValidator,
      this.autoFocus = false,
      this.required = false});

  @override
  State<FormTextArea> createState() => _FormTextAreaState();
}

class _FormTextAreaState extends State<FormTextArea> {
  String? _validateInput(String? value) {
    if (widget.required && (value == null || value.isEmpty)) {
      return "O campo \"${widget.fieldName}\" não pode ser vazio.";
    }

    if (widget.customValidator != null) {
      return widget.customValidator!(value);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      labelText: widget.labelText,
    );

    decoration.applyDefaults(Theme.of(context).inputDecorationTheme);

    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 10,
          controller: widget.controller,
          autofocus: widget.autoFocus,
          decoration: decoration,
          validator: _validateInput,
        ),
        const SizedBox(height: 10.0)
      ],
    );
  }
}
