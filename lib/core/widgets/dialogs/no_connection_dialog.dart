library;

import 'package:flutter/material.dart';

class NoConnectionDialog extends StatelessWidget {
  const NoConnectionDialog({this.onRetry, super.key});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.cloud_off),
      title: const Text('No internet connection'),
      content: const Text('Please check your network and try again.'),
      actions: [
        if (onRetry != null)
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Dismiss'),
        ),
      ],
    );
  }
}

Future<void> showNoConnectionDialog(
  BuildContext context, {
  VoidCallback? onRetry,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => NoConnectionDialog(onRetry: onRetry),
  );
}
