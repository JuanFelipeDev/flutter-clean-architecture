/// Home shell — reproduces AFILIADO's `DrawerActivity`:
/// bottom nav with 4 tabs. Each tab embeds the actual feature page directly
/// (not a button to open a route) — matching AFILIADO where each tab IS the
/// fragment (ItemFamilyFragment, NotificationsActivity, TrackingFragment,
/// GenericFragment/VIEW_CONFIGURATIONS).
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../assistance/presentation/pages/assistance_page.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../tracking/presentation/pages/tracking_page.dart';

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
        // Each tab IS the feature page (embedded, not a button).
        children: const [
          AssistancePage(),
          NotificationsPage(),
          TrackingPage(),
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

/// Tab 4 — Menú: the options list (AFILIADO's `GenericFragment` /
/// VIEW_CONFIGURATIONS). Each option navigates to its route.
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
    return Scaffold(
      appBar: AppBar(title: const Text('Configuraciones')),
      body: ListView.separated(
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
      ),
    );
  }
}

class _MenuOption {
  const _MenuOption({required this.icon, required this.label, required this.route});
  final IconData icon;
  final String label;
  final String route;
}