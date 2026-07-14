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
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push(AppRoute.settings.path),
            ),
            IconButton(
              icon: const Icon(Icons.directions_car_outlined),
              onPressed: () => context.push(AppRoute.vehicle.path),
            ),
            IconButton(
              icon: const Icon(Icons.groups_outlined),
              onPressed: () => context.push(AppRoute.beneficiary.path),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => context.push(AppRoute.profile.path),
            ),
          ],
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
            _ActionTab(label: 'Shop', route: AppRoute.payment.path),
            _ActionTab(label: 'Assistance', route: AppRoute.assistance.path),
            _ActionTab(label: 'Tracking', route: AppRoute.tracking.path),
            _ActionTab(label: 'Notifications', route: AppRoute.notifications.path),
          ],
        ),
      ),
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