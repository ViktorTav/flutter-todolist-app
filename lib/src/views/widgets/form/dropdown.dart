import 'package:flutter/material.dart';

class FormDropdown<T> extends StatefulWidget {
  final String labelText;
  final List<DropdownMenuItem<T>> items;
  final int initialValueIndex;
  final bool enabled;
  final String? Function(T?)? validator;

  FormDropdown(
      {super.key,
      required this.labelText,
      required this.items,
      required this.initialValueIndex,
      this.validator,
      this.enabled = true}) {
    assert(initialValueIndex >= 0 && initialValueIndex < items.length,
        "The initial value index is out of bounds of items list");
  }

  @override
  State<FormDropdown> createState() => FormDropdownState<T>();
}

class FormDropdownState<T> extends State<FormDropdown<T>> {
  T? value;

  @override
  void initState() {
    value = widget.items[widget.initialValueIndex].value;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      //Dessa maneira o suffixIcon fica alinhado com os suffixIcons de outros inputs
      contentPadding:
          const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 10),
      labelText: widget.labelText,
    );

    decoration.applyDefaults(Theme.of(context).inputDecorationTheme);

    return ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<T>(
            validator: widget.validator,
            decoration: decoration,
            value: value,
            items: widget.enabled ? widget.items : null,
            onChanged: (value) {
              setState(() {
                this.value = value;
              });
            }));
  }
}
