/// optional retry action.
library;

import 'package:flutter/material.dart';

import '../../error/failures.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({required this.failure, this.onRetry, super.key});

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.error_outline),
      title: const Text('Something went wrong'),
      content: Text(failure.message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Dismiss'),
        ),
        if (onRetry != null)
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}

/// Convenience to show an [ErrorDialog] from any context.
Future<void> showErrorDialog(
  BuildContext context,
  Failure failure, {
  VoidCallback? onRetry,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => ErrorDialog(failure: failure, onRetry: onRetry),
  );
}
