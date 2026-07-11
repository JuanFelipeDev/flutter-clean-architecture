/// Loading widgets (PRESTADOR `LoadingDialog` / `LoadingScreen`).
library;

import 'package:flutter/material.dart';

import '../theme/spacing.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({this.label, super.key});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        if (label != null) ...[
          const SizedBox(height: Spacing.md),
          Text(label!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    );
  }
}

/// Full-screen centered loading.
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({this.label, super.key});
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Center(child: LoadingIndicator(label: label));
  }
}

/// Modal loading overlay shown above content while an async op runs.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({required this.isLoading, required this.child, super.key});
  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.3),
              child: const LoadingScreen(),
            ),
          ),
      ],
    );
  }
}