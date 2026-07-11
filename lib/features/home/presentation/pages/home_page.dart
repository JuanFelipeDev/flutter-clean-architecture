/// Home shell — PLACEHOLDER. Phase 5 implements the real `DrawerActivity`
/// hub: bottom nav (`assistance | notifications | tracking | main`) + drawer,
/// with items gated by `configuraciones_app_afiliado/` flags. For Phase 3 this
/// is a shell with the four tabs as stubs.
library;

import 'package:flutter/material.dart';

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
        body: const TabBarView(
          children: [
            _PlaceholderTab('Home'),
            _PlaceholderTab('Assistance'),
            _PlaceholderTab('Tracking'),
            _PlaceholderTab('Notifications'),
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
      child: Text(
        '$label — Phase 5',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}