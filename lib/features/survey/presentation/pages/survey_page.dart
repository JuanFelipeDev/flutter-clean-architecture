/// Survey screen — quality questions + submit (AFILIADO `SurveyScreen`).
/// Receives an `assistanceId` via the route.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/toast.dart';
import '../../domain/entities/survey_entities.dart';
import '../providers/survey_providers.dart';
import '../states/survey_state.dart';

class SurveyPage extends ConsumerStatefulWidget {
  const SurveyPage({required this.assistanceId, super.key});
  final String assistanceId;

  @override
  ConsumerState<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends ConsumerState<SurveyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(surveyProvider, _onChanged);
      ref.read(surveyProvider.notifier).load(widget.assistanceId);
    });
  }

  void _onChanged(SurveyState? previous, SurveyState next) {
    if (next.status == SurveyStatus.success) {
      context.showToast('Thanks for your feedback', kind: ToastKind.success);
      Navigator.of(context).pop();
    } else if (next.status == SurveyStatus.failure) {
      context.showToast(next.errorMessage ?? 'Error', kind: ToastKind.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(surveyProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Survey')),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.status == SurveyStatus.loading || state.status == SurveyStatus.submitting,
          child: state.questions.isEmpty
              ? const Center(child: Text('No survey'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.questions.length,
                        itemBuilder: (context, i) {
                          final q = state.questions[i];
                          return _QuestionTile(
                            question: q,
                            selected: state.answers[q.id],
                            onSelect: (value) =>
                                ref.read(surveyProvider.notifier).setAnswer(q.id, value),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: FilledButton(
                        onPressed: () {
                          ref.read(surveyProvider.notifier).submit();
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  const _QuestionTile({required this.question, required this.selected, required this.onSelect});
  final SurveyQuestion question;
  final String? selected;
  final void Function(String) onSelect;

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
            onTap: () => onSelect(option),
          ),
      ],
    );
  }
}