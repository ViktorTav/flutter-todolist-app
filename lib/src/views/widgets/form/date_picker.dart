import 'package:flutter/material.dart';
import 'package:widget/src/util/date.dart';
import 'package:widget/src/views/widgets/form/input.dart';

class FormDatePicker extends StatefulWidget {
  final String fieldName, labelText;
  final bool autoFocus, required;
  final TextEditingController controller;
  final void Function(DateTime? value)? onChanged;

  const FormDatePicker(
      {super.key,
      required this.fieldName,
      required this.labelText,
      required this.controller,
      this.onChanged,
      this.autoFocus = false,
      this.required = false});

  @override
  State<FormDatePicker> createState() => FormDatePickerState();
}

class FormDatePickerState extends State<FormDatePicker> {
  DateTime? _date;

  DateTime? get date => _date;

  String? _validateInput(String? value) {
    if (_date == null) return null;

    final DateTime currentTime = DateTime.now();
    final DateTime date = _date!;

    if (date.isBefore(currentTime)) {
      return "Não é possível criar uma tarefa para uma data anterior do que atual";
    }

    return null;
  }

  Future<DateTime?> selectDate() async {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2200));
  }

  Future<TimeOfDay?> selectTime() async {
    return showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  Future<void> _handleTap() async {
    final DateTime? date = await selectDate();
    if (date == null) return;

    final TimeOfDay? time = await selectTime();
    if (time == null) return;

    final DateTime newDate =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    _date = newDate;
    widget.controller.text = convertToLocalDate(_date!);

    if (widget.onChanged != null) {
      widget.onChanged!(newDate);
    }
  }

  void _handleSuffixIconPressed() {
    widget.controller.clear();
    _date = null;

    if (widget.onChanged != null) {
      widget.onChanged!(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormInput(
      suffixIcon: Icons.delete_outline_outlined,
      suffixIconOnPressed: _handleSuffixIconPressed,
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
