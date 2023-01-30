import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  final String fieldName, labelText;
  final bool autoFocus, required, readOnly;
  final TextEditingController? controller;
  final String? Function(String? value)? customValidator;
  final void Function(BuildContext context)? onTap;

  const FormInput(
      {super.key,
      required this.fieldName,
      required this.labelText,
      this.onTap,
      this.controller,
      this.customValidator,
      this.autoFocus = false,
      this.required = false,
      this.readOnly = false});

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
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
    final decoration = InputDecoration(labelText: widget.labelText);

    decoration.applyDefaults(Theme.of(context).inputDecorationTheme);

    return Column(
      children: [
        TextFormField(
          onTap: widget.onTap == null
              ? null
              : () {
                  widget.onTap!(context);
                },
          controller: widget.controller,
          autofocus: widget.autoFocus,
          decoration: decoration,
          validator: _validateInput,
          readOnly: widget.readOnly,
        ),
        const SizedBox(height: 10.0)
      ],
    );
  }
}
