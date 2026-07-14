/// Assistance wizard state (AFILIADO plans -> families -> services ->
/// coverage questions -> create).
library;

import '../../domain/entities/assistance_entities.dart';

enum AssistanceStep { accounts, plans, families, services, questions, address, done }
enum AssistanceStatus { idle, loading, success, failure }

class AssistanceState {
  const AssistanceState({
    this.step = AssistanceStep.accounts,
    this.accounts = const [],
    this.plans = const [],
    this.families = const [],
    this.services = const [],
    this.questions = const [],
    this.selectedAccountId,
    this.selectedPlanId,
    this.selectedFamilyId,
    this.selectedServiceId,
    this.answers = const {},
    this.suggestions = const [],
    this.address = '',
    this.createdAssistanceId,
    this.status = AssistanceStatus.idle,
    this.errorMessage,
  });

  final AssistanceStep step;
  final List<Account> accounts;
  final List<Plan> plans;
  final List<ServiceFamily> families;
  final List<Service> services;
  final List<CoverageQuestion> questions;
  final String? selectedAccountId;
  final String? selectedPlanId;
  final String? selectedFamilyId;
  final String? selectedServiceId;
  final Map<String, String> answers;
  final List<PlaceSuggestion> suggestions;
  final String address;
  final String? createdAssistanceId;
  final AssistanceStatus status;
  final String? errorMessage;

  AssistanceState copyWith({
    AssistanceStep? step,
    List<Account>? accounts,
    List<Plan>? plans,
    List<ServiceFamily>? families,
    List<Service>? services,
    List<CoverageQuestion>? questions,
    String? selectedAccountId,
    String? selectedPlanId,
    String? selectedFamilyId,
    String? selectedServiceId,
    Map<String, String>? answers,
    List<PlaceSuggestion>? suggestions,
    String? address,
    String? createdAssistanceId,
    AssistanceStatus? status,
    String? errorMessage,
  }) {
    return AssistanceState(
      step: step ?? this.step,
      accounts: accounts ?? this.accounts,
      plans: plans ?? this.plans,
      families: families ?? this.families,
      services: services ?? this.services,
      questions: questions ?? this.questions,
      selectedAccountId: selectedAccountId ?? this.selectedAccountId,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      selectedFamilyId: selectedFamilyId ?? this.selectedFamilyId,
      selectedServiceId: selectedServiceId ?? this.selectedServiceId,
      answers: answers ?? this.answers,
      suggestions: suggestions ?? this.suggestions,
      address: address ?? this.address,
      createdAssistanceId: createdAssistanceId ?? this.createdAssistanceId,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}