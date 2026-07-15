/// Assistance wizard (AFILIADO plans -> families -> services -> coverage
/// questions -> address -> create). A single page rendering the current step
/// driven by [AssistanceState.step].
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/toast.dart';
import '../../domain/entities/assistance_entities.dart';
import '../providers/assistance_providers.dart';
import '../states/assistance_state.dart';

class AssistancePage extends ConsumerStatefulWidget {
  const AssistancePage({super.key});

  @override
  ConsumerState<AssistancePage> createState() => _AssistancePageState();
}

class _AssistancePageState extends ConsumerState<AssistancePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(assistanceProvider, _onStateChanged);
      ref.read(assistanceProvider.notifier).loadAccounts();
    });
  }

  void _onStateChanged(AssistanceState? previous, AssistanceState next) {
    if (next.status == AssistanceStatus.failure) {
      context.showToast(next.errorMessage ?? 'Error', kind: ToastKind.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assistanceProvider);
    return Scaffold(
      appBar: AppBar(title: Text(_title(state.step))),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.status == AssistanceStatus.loading,
          child: _step(context, state),
        ),
      ),
    );
  }

  String _title(AssistanceStep step) => switch (step) {
    AssistanceStep.accounts => 'Accounts',
    AssistanceStep.plans => 'Plans',
    AssistanceStep.families => 'Families',
    AssistanceStep.services => 'Services',
    AssistanceStep.questions => 'Coverage questions',
    AssistanceStep.address => 'Address',
    AssistanceStep.done => 'Done',
  };

  Widget _step(BuildContext context, AssistanceState state) {
    final notifier = ref.read(assistanceProvider.notifier);
    switch (state.step) {
      case AssistanceStep.accounts:
        return _SelectionList<Account>(
          items: state.accounts,
          title: (a) => a.name,
          subtitle: (a) => a.number,
          icon: Icons.account_balance_wallet_outlined,
          onSelected: (a) => notifier.selectAccount(a.id),
        );
      case AssistanceStep.plans:
        return _SelectionList<Plan>(
          items: state.plans,
          title: (p) => p.name,
          subtitle: (p) => p.description,
          icon: Icons.card_membership_outlined,
          onSelected: (p) => notifier.selectPlan(p.id),
        );
      case AssistanceStep.families:
        return _SelectionList<ServiceFamily>(
          items: state.families,
          title: (f) => f.name,
          icon: Icons.category_outlined,
          onSelected: (f) => notifier.selectFamily(f.id),
        );
      case AssistanceStep.services:
        return _SelectionList<Service>(
          items: state.services,
          title: (s) => s.name,
          subtitle: (s) => s.description,
          icon: Icons.handshake_outlined,
          onSelected: (s) => notifier.selectService(s.id),
        );
      case AssistanceStep.questions:
        return _QuestionsStep(
          questions: state.questions,
          answers: state.answers,
          onAnswer: notifier.setAnswer,
          onContinue: notifier.completeQuestions,
        );
      case AssistanceStep.address:
        return _AddressStep(
          suggestions: state.suggestions,
          address: state.address,
          onChanged: notifier.autocompleteAddress,
          onPicked: (s) {
            notifier.setAddress(s.description);
          },
          onCreate: notifier.create,
        );
      case AssistanceStep.done:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 64),
              const SizedBox(height: 16),
              Text('Assistance ${state.createdAssistanceId ?? ''} created'),
            ],
          ),
        );
    }
  }
}

class _SelectionList<T> extends StatelessWidget {
  const _SelectionList({
    required this.items,
    required this.title,
    this.subtitle,
    this.icon = Icons.account_circle_outlined,
    required this.onSelected,
  });

  final List<T> items;
  final String Function(T) title;
  final String? Function(T)? subtitle;
  final IconData icon;
  final void Function(T) onSelected;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text('No items', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        final sub = subtitle?.call(item);
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(child: Icon(icon, size: 22)),
            title: Text(title(item), style: Theme.of(context).textTheme.titleSmall),
            subtitle: sub != null ? Text(sub) : null,
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => onSelected(item),
          ),
        );
      },
    );
  }
}

class _QuestionsStep extends StatelessWidget {
  const _QuestionsStep({
    required this.questions,
    required this.answers,
    required this.onAnswer,
    required this.onContinue,
  });

  final List<CoverageQuestion> questions;
  final Map<String, String> answers;
  final void Function(String, String) onAnswer;
  final Future<void> Function() onContinue;

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Center(child: Text('No questions'));
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: questions.length,
            itemBuilder: (context, i) {
              final q = questions[i];
              return _QuestionTile(question: q, selected: answers[q.id], onAnswer: onAnswer);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () => onContinue(),
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}

class _QuestionTile extends StatelessWidget {
  const _QuestionTile({required this.question, required this.selected, required this.onAnswer});
  final CoverageQuestion question;
  final String? selected;
  final void Function(String, String) onAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(question.text, style: Theme.of(context).textTheme.titleMedium),
        ),
        for (final option in question.options)
          ListTile(
            title: Text(option),
            trailing: selected == option ? const Icon(Icons.check) : null,
            onTap: () => onAnswer(question.id, option),
          ),
      ],
    );
  }
}

class _AddressStep extends StatefulWidget {
  const _AddressStep({
    required this.suggestions,
    required this.address,
    required this.onChanged,
    required this.onPicked,
    required this.onCreate,
  });

  final List<PlaceSuggestion> suggestions;
  final String address;
  final Future<void> Function(String) onChanged;
  final void Function(PlaceSuggestion) onPicked;
  final Future<void> Function() onCreate;

  @override
  State<_AddressStep> createState() => _AddressStepState();
}

class _AddressStepState extends State<_AddressStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Address'),
            onChanged: (value) => widget.onChanged(value),
          ),
          const SizedBox(height: 8),
          if (widget.suggestions.isNotEmpty)
            Expanded(
              child: ListView(
                children: [
                  for (final s in widget.suggestions)
                    ListTile(
                      title: Text(s.description),
                      onTap: () {
                        _controller.text = s.description;
                        widget.onPicked(s);
                      },
                    ),
                ],
              ),
            )
          else
            const Spacer(),
          FilledButton(onPressed: () => widget.onCreate(), child: const Text('Request assistance')),
        ],
      ),
    );
  }
}