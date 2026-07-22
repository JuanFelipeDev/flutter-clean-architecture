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
    this.obscureTextToggle = false,
    this.keyboardType,
    this.prefixIcon,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final List<FieldValidator> validators;
  final bool obscureText;
  /// When true (and [obscureText] is true), renders a suffix toggle to show /
  /// hide the value. Used for password fields.
  final bool obscureTextToggle;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;

  @override
  State<ValidatedTextField> createState() => ValidatedTextFieldState();
}

class ValidatedTextFieldState extends State<ValidatedTextField> {
  String? _error;
  bool _obscured = true;

  String? _validate(String value) {
    for (final validator in widget.validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }

  /// Re-runs the validators on the current controller value and surfaces the
  /// first error. Exposed so a parent can re-validate this field when a
  /// counterpart field changes (e.g. password confirmation).
  String? validate() {
    final error = _validate(widget.controller.text);
    setState(() => _error = error);
    return error;
  }

  @override
  Widget build(BuildContext context) {
    final showToggle = widget.obscureText && widget.obscureTextToggle;
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText && (!showToggle || _obscured),
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: _error,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: showToggle
            ? IconButton(
                icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscured = !_obscured),
              )
            : null,
      ),
      onChanged: (value) {
        setState(() => _error = _validate(value));
        widget.onChanged?.call(value);
      },
    );
  }
}