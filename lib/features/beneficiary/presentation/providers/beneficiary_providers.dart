/// Riverpod wiring for the beneficiary feature. [BeneficiaryNotifier] loads the
/// list + relationships and subscribes to the beneficiary socket channel for
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/session/session_providers.dart';
import '../../../../core/socket/socket_event.dart';
import '../../../../core/socket/socket_providers.dart';
import '../../data/datasources/beneficiary_remote_data_source.dart';
import '../../data/models/beneficiary_dtos.dart';
import '../../data/repositories/beneficiary_repository_impl.dart';
import '../../domain/entities/beneficiary_entities.dart';
import '../../domain/repositories/beneficiary_repository.dart';
import '../../domain/usecases/beneficiary_usecases.dart';
import '../states/beneficiary_state.dart';

final beneficiaryRemoteDataSourceProvider =
    Provider<BeneficiaryRemoteDataSource>((ref) {
      return BeneficiaryRemoteDataSource(ref.watch(dioProvider));
    });

final beneficiaryRepositoryProvider = Provider<BeneficiaryRepository>((ref) {
  return BeneficiaryRepositoryImpl(
    remoteDataSource: ref.watch(beneficiaryRemoteDataSourceProvider),
    mapper: const BeneficiaryMapper(),
  );
});

final getBeneficiariesUseCaseProvider = Provider<GetBeneficiariesUseCase>((
  ref,
) {
  return GetBeneficiariesUseCase(ref.watch(beneficiaryRepositoryProvider));
});

final createBeneficiaryUseCaseProvider = Provider<CreateBeneficiaryUseCase>((
  ref,
) {
  return CreateBeneficiaryUseCase(ref.watch(beneficiaryRepositoryProvider));
});

final updateBeneficiaryUseCaseProvider = Provider<UpdateBeneficiaryUseCase>((
  ref,
) {
  return UpdateBeneficiaryUseCase(ref.watch(beneficiaryRepositoryProvider));
});

final deleteBeneficiaryUseCaseProvider = Provider<DeleteBeneficiaryUseCase>((
  ref,
) {
  return DeleteBeneficiaryUseCase(ref.watch(beneficiaryRepositoryProvider));
});

final getRelationshipsUseCaseProvider = Provider<GetRelationshipsUseCase>((
  ref,
) {
  return GetRelationshipsUseCase(ref.watch(beneficiaryRepositoryProvider));
});

class BeneficiaryNotifier extends Notifier<BeneficiaryState> {
  StreamSubscription<SocketEvent>? _socketSub;

  @override
  BeneficiaryState build() {
    ref.onDispose(() => _socketSub?.cancel());
    return const BeneficiaryState(status: BeneficiaryStatus.loading);
  }

  String? get _affKey => ref.read(cachedSessionProvider)?.affKey;

  Future<void> load() async {
    final affKey = _affKey;
    if (affKey == null) {
      state = state.copyWith(
        status: BeneficiaryStatus.failure,
        errorMessage: 'No session',
      );
      return;
    }
    state = state.copyWith(status: BeneficiaryStatus.loading, errorMessage: '');
    final beneficiaries = await ref
        .read(getBeneficiariesUseCaseProvider)
        .call(affKey);
    final relationships = await ref
        .read(getRelationshipsUseCaseProvider)
        .call();

    state = state.copyWith(
      beneficiaries: beneficiaries.getOrNull() ?? const [],
      relationships: relationships.getOrNull() ?? const [],
      status: BeneficiaryStatus.idle,
    );

    final socketManager = ref.read(socketManagerProvider);
    await socketManager.connect(
      SocketChannel.beneficiary,
      auth: {'affkey': affKey},
    );
    _socketSub = socketManager.events.listen((event) {
      if (event is! RawSocketEvent ||
          event.channel != SocketChannel.beneficiary)
        return;
      final coords = const BeneficiaryMapper().parseCoordinates(event.payload);
      if (coords.beneficiaryId.isEmpty) return;
      final next = Map<String, BeneficiaryCoordinate>.from(state.coordinates);
      next[coords.beneficiaryId] = coords;
      state = state.copyWith(coordinates: next);
    });
  }

  Future<void> add(Beneficiary beneficiary) async {
    final affKey = _affKey;
    if (affKey == null) return;
    state = state.copyWith(status: BeneficiaryStatus.saving, errorMessage: '');
    final result = await ref
        .read(createBeneficiaryUseCaseProvider)
        .call(affKey, beneficiary);
    result.fold(
      onSuccess: (created) => state = state.copyWith(
        beneficiaries: [...state.beneficiaries, created],
        status: BeneficiaryStatus.idle,
      ),
      onFailure: (failure) => state = state.copyWith(
        status: BeneficiaryStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  Future<void> edit(Beneficiary beneficiary) async {
    state = state.copyWith(status: BeneficiaryStatus.saving, errorMessage: '');
    final result = await ref
        .read(updateBeneficiaryUseCaseProvider)
        .call(beneficiary);
    result.fold(
      onSuccess: (updated) => state = state.copyWith(
        beneficiaries: state.beneficiaries
            .map((b) => b.id == updated.id ? updated : b)
            .toList(),
        status: BeneficiaryStatus.idle,
      ),
      onFailure: (failure) => state = state.copyWith(
        status: BeneficiaryStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  Future<void> remove(String beneficiaryId) async {
    final result = await ref
        .read(deleteBeneficiaryUseCaseProvider)
        .call(beneficiaryId);
    result.fold(
      onSuccess: (_) => state = state.copyWith(
        beneficiaries: state.beneficiaries
            .where((b) => b.id != beneficiaryId)
            .toList(),
      ),
      onFailure: (failure) => state = state.copyWith(
        status: BeneficiaryStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  void select(String? id) => state = state.copyWith(selectedId: id);
}

final beneficiaryProvider =
    NotifierProvider<BeneficiaryNotifier, BeneficiaryState>(
      BeneficiaryNotifier.new,
    );
