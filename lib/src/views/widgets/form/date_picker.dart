import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:widget/src/views/widgets/form/input.dart';

class FormDatePicker extends StatefulWidget {
  final String fieldName, labelText;
  final bool autoFocus, required;
  final TextEditingController controller;

  const FormDatePicker(
      {super.key,
      required this.fieldName,
      required this.labelText,
      required this.controller,
      this.autoFocus = false,
      this.required = false});

  @override
  State<FormDatePicker> createState() => FormDatePickerState();
}

class FormDatePickerState extends State<FormDatePicker> {
  String? _validateInput(String? value) {
    return null;
  }

  Future<void> _handleTap(BuildContext context) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2200));

    if (date != null) {
      setState(() {
        widget.controller.text = DateFormat("dd-MM-yyyy").format(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormInput(
      fieldName: widget.fieldName,
      labelText: widget.labelText,
      autoFocus: widget.autoFocus,
      controller: widget.controller,
      customValidator: _validateInput,
      required: widget.required,
      onTap: _handleTap,
      readOnly: true,
    );
  }
}
