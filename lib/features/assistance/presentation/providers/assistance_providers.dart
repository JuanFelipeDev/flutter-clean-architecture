/// Riverpod wiring for the assistance feature.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/config_providers.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/error/result.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/session/session_providers.dart';
import '../../data/datasources/assistance_remote_data_source.dart';
import '../../data/models/assistance_dtos.dart';
import '../../data/repositories/assistance_repository_impl.dart';
import '../../domain/entities/assistance_entities.dart';
import '../../domain/repositories/assistance_repository.dart';
import '../../domain/usecases/assistance_usecases.dart';
import '../states/assistance_state.dart';

/// A separate Dio for Google Places (different base host + timeout). Uses the
/// flavor maps key via dart-define when configured; otherwise the same base.
final placesDioProvider = Provider<Dio>((ref) {
  final flavor = ref.watch<FlavorConfig>(flavorConfigProvider);
  return Dio(BaseOptions(
    baseUrl: 'https://places.googleapis.com/',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'X-Goog-Api-Key': flavor.mapsApiKey},
  ));
});

final assistanceRemoteDataSourceProvider = Provider<AssistanceRemoteDataSource>((ref) {
  return AssistanceRemoteDataSource(ref.watch(dioProvider));
});

final placesRemoteDataSourceProvider = Provider<PlacesRemoteDataSource>((ref) {
  return PlacesRemoteDataSource(ref.watch(placesDioProvider));
});

final assistanceRepositoryProvider = Provider<AssistanceRepository>((ref) {
  return AssistanceRepositoryImpl(
    remoteDataSource: ref.watch(assistanceRemoteDataSourceProvider),
    mapper: const AssistanceMapper(),
  );
});

final placesRepositoryProvider = Provider<PlacesRepository>((ref) {
  return PlacesRepositoryImpl(
    remoteDataSource: ref.watch(placesRemoteDataSourceProvider),
    mapper: const AssistanceMapper(),
  );
});

final getAccountsUseCaseProvider = Provider<GetAccountsUseCase>((ref) {
  return GetAccountsUseCase(ref.watch(assistanceRepositoryProvider));
});

final getPlansUseCaseProvider = Provider<GetPlansUseCase>((ref) {
  return GetPlansUseCase(ref.watch(assistanceRepositoryProvider));
});

final getFamiliesUseCaseProvider = Provider<GetFamiliesUseCase>((ref) {
  return GetFamiliesUseCase(ref.watch(assistanceRepositoryProvider));
});

final getServicesUseCaseProvider = Provider<GetServicesUseCase>((ref) {
  return GetServicesUseCase(ref.watch(assistanceRepositoryProvider));
});

final getCoverageQuestionsUseCaseProvider = Provider<GetCoverageQuestionsUseCase>((ref) {
  return GetCoverageQuestionsUseCase(ref.watch(assistanceRepositoryProvider));
});

final createAssistanceUseCaseProvider = Provider<CreateAssistanceUseCase>((ref) {
  return CreateAssistanceUseCase(ref.watch(assistanceRepositoryProvider));
});

final autocompletePlacesUseCaseProvider = Provider<AutocompletePlacesUseCase>((ref) {
  return AutocompletePlacesUseCase(ref.watch(placesRepositoryProvider));
});

class AssistanceNotifier extends Notifier<AssistanceState> {
  @override
  AssistanceState build() => const AssistanceState();

  String? get _affKey => ref.read(cachedSessionProvider)?.affKey;

  Future<void> loadAccounts() async {
    final affKey = _affKey;
    if (affKey == null) {
      state = state.copyWith(status: AssistanceStatus.failure, errorMessage: 'No session');
      return;
    }
    state = state.copyWith(status: AssistanceStatus.loading, errorMessage: '');
    final result = await ref.read(getAccountsUseCaseProvider).call(affKey);
    _apply(result, (accounts) => state = state.copyWith(
      accounts: accounts,
      status: AssistanceStatus.idle,
    ));
  }

  Future<void> selectAccount(String accountId) async {
    final affKey = _affKey;
    if (affKey == null) return;
    state = state.copyWith(selectedAccountId: accountId, status: AssistanceStatus.loading);
    final result = await ref.read(getPlansUseCaseProvider).call(affKey, accountId);
    _apply(result, (plans) => state = state.copyWith(
      plans: plans,
      step: AssistanceStep.plans,
      status: AssistanceStatus.idle,
    ));
  }

  Future<void> selectPlan(String planId) async {
    final affKey = _affKey;
    if (affKey == null) return;
    state = state.copyWith(selectedPlanId: planId, status: AssistanceStatus.loading);
    final result = await ref.read(getFamiliesUseCaseProvider).call(affKey, planId);
    _apply(result, (families) => state = state.copyWith(
      families: families,
      step: AssistanceStep.families,
      status: AssistanceStatus.idle,
    ));
  }

  Future<void> selectFamily(String familyId) async {
    final affKey = _affKey;
    final planId = state.selectedPlanId;
    if (affKey == null || planId == null) return;
    state = state.copyWith(selectedFamilyId: familyId, status: AssistanceStatus.loading);
    final result = await ref.read(getServicesUseCaseProvider).call(affKey, planId, familyId);
    _apply(result, (services) => state = state.copyWith(
      services: services,
      step: AssistanceStep.services,
      status: AssistanceStatus.idle,
    ));
  }

  Future<void> selectService(String serviceId) async {
    state = state.copyWith(selectedServiceId: serviceId, status: AssistanceStatus.loading);
    final result = await ref.read(getCoverageQuestionsUseCaseProvider).call(serviceId);
    if (result is Success<List<CoverageQuestion>> && result.value.isEmpty) {
      // No coverage questions -> jump to address step.
      state = state.copyWith(step: AssistanceStep.address, status: AssistanceStatus.idle);
      return;
    }
    _apply(result, (questions) => state = state.copyWith(
      questions: questions,
      step: AssistanceStep.questions,
      status: AssistanceStatus.idle,
    ));
  }

  void setAnswer(String questionId, String answer) {
    final answers = Map<String, String>.from(state.answers)..[questionId] = answer;
    state = state.copyWith(answers: answers);
  }

  Future<void> completeQuestions() async {
    state = state.copyWith(step: AssistanceStep.address, status: AssistanceStatus.idle);
  }

  Future<void> autocompleteAddress(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(suggestions: const []);
      return;
    }
    final result = await ref.read(autocompletePlacesUseCaseProvider).call(query);
    _apply(result, (suggestions) => state = state.copyWith(suggestions: suggestions));
  }

  void setAddress(String address) => state = state.copyWith(address: address, suggestions: const []);

  Future<void> create() async {
    final affKey = _affKey;
    final serviceId = state.selectedServiceId;
    final accountId = state.selectedAccountId;
    if (affKey == null || serviceId == null || accountId == null) return;
    state = state.copyWith(status: AssistanceStatus.loading, errorMessage: '');
    final answers = state.answers.entries
        .map((e) => CoverageAnswer(questionId: e.key, answer: e.value))
        .toList();
    final result = await ref.read(createAssistanceUseCaseProvider).call(
      affKey: affKey,
      serviceId: serviceId,
      accountId: accountId,
      address: state.address,
      answers: answers,
    );
    result.fold(
      onSuccess: (assistance) => state = state.copyWith(
        step: AssistanceStep.done,
        status: AssistanceStatus.success,
        createdAssistanceId: assistance.id,
      ),
      onFailure: (failure) => state = state.copyWith(
        status: AssistanceStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  void _apply<T>(Result<T> result, void Function(T) onSuccess) {
    result.fold(
      onSuccess: onSuccess,
      onFailure: (failure) => state = state.copyWith(
        status: AssistanceStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  void backTo(AssistanceStep step) =>
      state = state.copyWith(step: step, status: AssistanceStatus.idle, errorMessage: '');
}

final assistanceProvider =
    NotifierProvider<AssistanceNotifier, AssistanceState>(AssistanceNotifier.new);