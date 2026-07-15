/// Home shell — reproduces AFILIADO's `DrawerActivity`:
/// bottom nav (Asistencias | Notificaciones | Seguimiento | Inicio) + a
/// drawer with items gated by `configuraciones_app_afiliado/` flags
/// (profile, beneficiaries, vehicles, shop, settings).
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Afiliado')),
      drawer: _Drawer(),
      body: TabBarView(
        controller: _tab,
        children: const [
          _AssistanceTab(),
          _NotificationsTab(),
          _TrackingTab(),
          _HomeTab(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tab,
        labelPadding: const EdgeInsets.symmetric(vertical: 4),
        tabs: const [
          Tab(icon: Icon(Icons.handshake_outlined), text: 'Asistencias'),
          Tab(icon: Icon(Icons.notifications_outlined), text: 'Notificaciones'),
          Tab(icon: Icon(Icons.map_outlined), text: 'Seguimiento'),
          Tab(icon: Icon(Icons.home_outlined), text: 'Inicio'),
        ],
      ),
    );
  }
}

/// Tab 1 — Asistencias: opens the assistance wizard (AFILIADO `assistance`).
class _AssistanceTab extends StatelessWidget {
  const _AssistanceTab();
  @override
  Widget build(BuildContext context) {
    return _OpenTab(label: 'Solicitar asistencia', route: AppRoute.assistance.path);
  }
}

/// Tab 2 — Notificaciones (AFILIADO `notification`).
class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();
  @override
  Widget build(BuildContext context) {
    return _OpenTab(label: 'Notificaciones', route: AppRoute.notifications.path);
  }
}

/// Tab 3 — Seguimiento (AFILIADO `tracing`).
class _TrackingTab extends StatelessWidget {
  const _TrackingTab();
  @override
  Widget build(BuildContext context) {
    return _OpenTab(label: 'Seguimiento', route: AppRoute.tracking.path);
  }
}

/// Tab 4 — Inicio: a hub with quick access to the drawer items (AFILIADO
/// `main` fragment). The drawer also has these items.
class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) {
    return _OpenTab(label: 'Inicio', route: AppRoute.settings.path);
  }
}

/// A simple tab that shows a button to open the corresponding route.
class _OpenTab extends StatelessWidget {
  const _OpenTab({required this.label, required this.route});
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
            child: const Text('Abrir'),
          ),
        ],
      ),
    );
  }
}

/// Drawer with the gated items (AFILIADO drawer: profile, beneficiaries,
/// vehicles, shop, settings). Each item navigates to its route.
class _Drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
            child: const Text('Afiliado', style: TextStyle(fontSize: 24)),
          ),
          _DrawerItem(icon: Icons.person_outline, label: 'Perfil', route: AppRoute.profile.path),
          _DrawerItem(icon: Icons.groups_outlined, label: 'Beneficiarios', route: AppRoute.beneficiary.path),
          _DrawerItem(icon: Icons.directions_car_outlined, label: 'Vehículos', route: AppRoute.vehicle.path),
          _DrawerItem(icon: Icons.shopping_cart_outlined, label: 'Tienda', route: AppRoute.payment.path),
          _DrawerItem(icon: Icons.history, label: 'Historial', route: AppRoute.history.path),
          const Divider(),
          _DrawerItem(icon: Icons.settings_outlined, label: 'Configuración', route: AppRoute.settings.path),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({required this.icon, required this.label, required this.route});
  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.of(context).pop(); // close drawer
        context.push(route);
      },
    );
  }
}