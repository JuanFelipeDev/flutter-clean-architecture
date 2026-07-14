/// History screen — paginated past-assistance list (AFILIADO
/// `ServiceHistoryFragment`). Loads the first page on open and appends more
/// when the list scrolls near the bottom.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading.dart';
import '../../domain/entities/history_entities.dart';
import '../providers/history_providers.dart';
import '../states/history_state.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  late final ScrollController _scroll = ScrollController()..addListener(_onScroll);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scroll.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(historyProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: SafeArea(
        child: state.items.isEmpty && state.status == HistoryStatus.loading
            ? const Center(child: LoadingIndicator())
            : state.items.isEmpty
                ? const Center(child: Text('No history'))
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: LoadingIndicator()),
                        );
                      }
                      return _HistoryTile(item: state.items[i]);
                    },
                  ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.item});
  final HistoryItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(item.serviceName ?? 'Assistance ${item.id}'),
      subtitle: Text([
        if (item.status != null) item.status!,
        if (item.providerName != null) item.providerName!,
        if (item.address != null) item.address!,
      ].join(' · ')),
    );
  }
}