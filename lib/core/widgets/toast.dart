/// Lightweight toast helper (AFILIADO/PRESTADOR `ToastMessage`).
library;

import 'package:flutter/material.dart';

enum ToastKind { info, success, error }

extension ToastContext on BuildContext {
  void showToast(String message, {ToastKind kind = ToastKind.info}) {
    final theme = Theme.of(this);
    final color = switch (kind) {
      ToastKind.info => theme.colorScheme.primary,
      ToastKind.success => Colors.green,
      ToastKind.error => theme.colorScheme.error,
    };

    ScaffoldMessenger.maybeOf(this)?.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
      ),
    );
  }
}