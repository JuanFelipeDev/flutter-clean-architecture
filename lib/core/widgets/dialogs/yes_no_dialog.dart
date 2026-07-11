/// Confirmation dialog (PRESTADOR `YesOrNotDialog`).
library;

import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  const YesNoDialog({
    required this.message,
    this.title = 'Confirm',
    this.yesLabel = 'Yes',
    this.noLabel = 'No',
    this.isDestructive = false,
    super.key,
  });

  final String title;
  final String message;
  final String yesLabel;
  final String noLabel;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(noLabel),
        ),
        FilledButton(
          style: isDestructive
              ? FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error)
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(yesLabel),
        ),
      ],
    );
  }
}

Future<bool?> showYesNoDialog(
  BuildContext context, {
  required String message,
  String title = 'Confirm',
  String yesLabel = 'Yes',
  String noLabel = 'No',
  bool isDestructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => YesNoDialog(
      title: title,
      message: message,
      yesLabel: yesLabel,
      noLabel: noLabel,
      isDestructive: isDestructive,
    ),
  );
}