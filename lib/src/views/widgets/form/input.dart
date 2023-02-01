import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  final String fieldName, labelText;
  final bool autoFocus, required, readOnly;
  final TextEditingController? controller;
  final String? Function(String? value)? customValidator;
  final FocusNode inputFocus = FocusNode();
  final void Function()? onTap, suffixIconOnPressed;
  final IconData? suffixIcon;

  FormInput(
      {super.key,
      required this.fieldName,
      required this.labelText,
      this.onTap,
      this.controller,
      this.customValidator,
      this.suffixIcon,
      this.suffixIconOnPressed,
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

  void _handleSuffixIconPressed() {
    if (widget.suffixIconOnPressed == null) return;

    //https://github.com/flutter/flutter/issues/39376#issuecomment-612461063

    widget.inputFocus.unfocus();

    widget.inputFocus.canRequestFocus = false;

    widget.suffixIconOnPressed!();

    Future.delayed(const Duration(milliseconds: 100), () {
      widget.inputFocus.canRequestFocus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      labelText: widget.labelText,
      suffixIcon: widget.suffixIcon != null
          ? IconButton(
              onPressed: _handleSuffixIconPressed,
              icon: Icon(widget.suffixIcon))
          : null,
    );

    decoration.applyDefaults(Theme.of(context).inputDecorationTheme);

    return Column(
      children: [
        TextFormField(
          focusNode: widget.inputFocus,
          autocorrect: true,
          onTap: widget.onTap == null
              ? null
              : () {
                  widget.onTap!();
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
