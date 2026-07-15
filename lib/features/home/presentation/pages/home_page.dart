/// Home shell — reproduces AFILIADO's `DrawerActivity`:
/// bottom nav with 4 tabs (Asistencias | Notificaciones | Servicios Activos |
/// Menú). No side drawer — the "Menú" tab shows the options list (perfil,
/// beneficiarios, vehículos, historial, tienda, configuración), matching
/// AFILIADO's `GenericFragment` (VIEW_CONFIGURATIONS).
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
      body: TabBarView(
        controller: _tab,
        children: const [
          _AssistanceTab(),
          _NotificationsTab(),
          _TrackingTab(),
          _MenuTab(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tab,
        tabs: const [
          Tab(icon: Icon(Icons.handshake_outlined), text: 'Asistencias'),
          Tab(icon: Icon(Icons.notifications_outlined), text: 'Notificaciones'),
          Tab(icon: Icon(Icons.map_outlined), text: 'Servicios'),
          Tab(icon: Icon(Icons.menu), text: 'Menú'),
        ],
      ),
    );
  }
}

/// Tab 1 — Asistencias: opens the assistance request wizard.
class _AssistanceTab extends StatelessWidget {
  const _AssistanceTab();
  @override
  Widget build(BuildContext context) {
    return _OpenTab(label: 'Solicitar asistencia', route: AppRoute.assistance.path);
  }
}

/// Tab 2 — Notificaciones.
class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();
  @override
  Widget build(BuildContext context) {
    return _OpenTab(label: 'Notificaciones', route: AppRoute.notifications.path);
  }
}

/// Tab 3 — Servicios Activos (seguimiento).
class _TrackingTab extends StatelessWidget {
  const _TrackingTab();
  @override
  Widget build(BuildContext context) {
    return _OpenTab(label: 'Seguimiento', route: AppRoute.tracking.path);
  }
}

/// Tab 4 — Menú: the options list (AFILIADO's `GenericFragment` /
/// VIEW_CONFIGURATIONS). Each option navigates to its route. In AFILIADO
/// these are gated by `configuraciones_app_afiliado/` flags — the flags
/// wiring follows when the settings feature loads the AppConfiguration.
class _MenuTab extends StatelessWidget {
  const _MenuTab();

  static final _options = <_MenuOption>[
    _MenuOption(icon: Icons.person_outline, label: 'Perfil', route: AppRoute.profile.path),
    _MenuOption(icon: Icons.groups_outlined, label: 'Beneficiarios', route: AppRoute.beneficiary.path),
    _MenuOption(icon: Icons.directions_car_outlined, label: 'Vehículos', route: AppRoute.vehicle.path),
    _MenuOption(icon: Icons.shopping_cart_outlined, label: 'Tienda', route: AppRoute.payment.path),
    _MenuOption(icon: Icons.history, label: 'Historial', route: AppRoute.history.path),
    _MenuOption(icon: Icons.settings_outlined, label: 'Configuración', route: AppRoute.settings.path),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _options.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final opt = _options[i];
        return ListTile(
          leading: Icon(opt.icon, color: Theme.of(context).colorScheme.primary),
          title: Text(opt.label),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(opt.route),
        );
      },
    );
  }
}

class _MenuOption {
  const _MenuOption({required this.icon, required this.label, required this.route});
  final IconData icon;
  final String label;
  final String route;
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