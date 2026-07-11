/// Validated text field (PRESTADOR `TextFieldGeneric`). Runs a list of
/// validators and surfaces the first error inline. The field is controlled by
/// the caller.
library;

import 'package:flutter/material.dart';

typedef FieldValidator = String? Function(String value);

class ValidatedTextField extends StatefulWidget {
  const ValidatedTextField({
    required this.controller,
    required this.label,
    this.validators = const [],
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final List<FieldValidator> validators;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;

  @override
  State<ValidatedTextField> createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField> {
  String? _error;

  String? _validate(String value) {
    for (final validator in widget.validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: _error,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
      ),
      onChanged: (value) {
        setState(() => _error = _validate(value));
        widget.onChanged?.call(value);
      },
    );
  }
}