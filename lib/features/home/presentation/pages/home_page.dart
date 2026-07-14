/// Home shell — PARTIAL. Implements the `DrawerActivity` hub bottom nav
/// (`home | assistance | tracking | notifications`). The assistance tab opens
/// the assistance wizard; the rest remain placeholders until their features
/// land. Drawer + per-item gating flags land with the settings feature.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home_outlined), text: 'Home'),
              Tab(icon: Icon(Icons.handshake_outlined), text: 'Assistance'),
              Tab(icon: Icon(Icons.map_outlined), text: 'Tracking'),
              Tab(icon: Icon(Icons.notifications_outlined), text: 'Notifications'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const _PlaceholderTab('Home'),
            _ActionTab(label: 'Assistance', route: AppRoute.assistance.path),
            _ActionTab(label: 'Tracking', route: AppRoute.tracking.path),
            const _PlaceholderTab('Notifications'),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$label — soon', style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _ActionTab extends StatelessWidget {
  const _ActionTab({required this.label, required this.route});
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.push(route),
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }
}