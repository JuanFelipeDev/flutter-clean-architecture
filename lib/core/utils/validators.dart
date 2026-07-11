/// Business validators reproduced from AFILIADO (`ConfigUtils.validatePassword`,
/// `VALID_EMAIL_ADDRESS_REGEX`, Roble field rules).
library;

import '../widgets/validated_text_field.dart';

class Validators {
  const Validators._();

  static const String _emailRegex =
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

  /// AFILIADO `VALID_PASSWORD`: digit + upper + lower + special, no spaces, ≥8.
  static const String _passwordRegex =
      r'^(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[^A-Za-z0-9])(?!.*\s).{8,}$';

  static FieldValidator required({String message = 'Required'}) {
    return (value) => value.trim().isEmpty ? message : null;
  }

  static FieldValidator email({String message = 'Invalid email'}) {
    return (value) => RegExp(_emailRegex).hasMatch(value) ? null : message;
  }

  static FieldValidator password({String message = 'Weak password'}) {
    return (value) => RegExp(_passwordRegex).hasMatch(value) ? null : message;
  }

  static FieldValidator minLength(int min, {String? message}) {
    return (value) => value.length >= min ? null : (message ?? 'Min $min characters');
  }

  /// Roble: requires at least 2 of 3 fields non-empty (checked at submit time,
  /// not per-field — kept here for reuse).
  static bool atLeastTwoFilled(List<String> values) {
    return values.where((v) => v.trim().isNotEmpty).length >= 2;
  }
}