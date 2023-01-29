import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  final String fieldName, labelText;
  final bool autoFocus, required;
  final TextEditingController? controller;
  final String? Function(String? value)? customValidator;

  const FormInput(
      {super.key,
      required this.fieldName,
      required this.labelText,
      this.controller,
      this.customValidator,
      this.autoFocus = false,
      this.required = false});

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
    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: widget.labelText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            filled: true,
            fillColor: Colors.grey[300],
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: 2.0, color: Theme.of(context).colorScheme.primary)),
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w300),
            focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: 2.0, color: Theme.of(context).colorScheme.error)),
          ),
          validator: _validateInput,
        ),
        const SizedBox(height: 10.0)
      ],
    );
  }
}
