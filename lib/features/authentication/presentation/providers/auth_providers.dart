/// Riverpod wiring for the authentication feature.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/config_providers.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/session/session_providers.dart';
import '../../../../core/session/session_state_provider.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/login_entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/two_factor_usecase.dart';
import '../states/login_state.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    storage: ref.watch(secureStorageProvider),
    onSessionChanged: (data) {
      ref.read(cachedSessionProvider.notifier).state = data;
      ref.read(isAuthenticatedProvider.notifier).state = data != null;
    },
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final twoFactorUseCaseProvider = Provider<TwoFactorUseCase>((ref) {
  return TwoFactorUseCase(ref.watch(authRepositoryProvider));
});

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() {
    final flavor = ref.watch(flavorConfigProvider);
    return LoginState(strategy: flavor.loginStrategy);
  }

  void setField(String key, String value) {
    state = state.copyWith(
      username: key == 'username' ? value : null,
      password: key == 'password' ? value : null,
      phone: key == 'phone' ? value : null,
      name: key == 'name' ? value : null,
      nit: key == 'nit' ? value : null,
      placa: key == 'placa' ? value : null,
      dpi: key == 'dpi' ? value : null,
      errorMessage: '',
    );
  }

  Future<void> submit({String? deviceToken}) async {
    final credentials = _credentials();
    if (credentials == null) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Incomplete credentials',
      );
      return;
    }

    state = state.copyWith(status: LoginStatus.loading, errorMessage: '');
    final result = await ref
        .read(loginUseCaseProvider)
        .call(credentials, deviceToken: deviceToken);

    result.fold(
      onSuccess: (session) {
        // ignore: avoid_print
        print(
          '[LOGIN] success: requiresTwoFactor=${session.requiresTwoFactor} '
          'twoFactorsAuth=${session.twoFactorsAuth} '
          'user=${session.user?.id} userName=${session.userName} '
          'affKey=${session.affKey} access=${session.accessToken.isNotEmpty}',
        );
        if (session.requiresTwoFactor) {
          state = state.copyWith(
            status: LoginStatus.requiresTwoFactor,
            twoFactorUserName: session.userName,
          );
        } else {
          state = state.copyWith(status: LoginStatus.success, errorMessage: '');
        }
      },
      onFailure: (failure) {
        // ignore: avoid_print
        print('[LOGIN] failure: ${failure.message} (${failure.kind})');
        state = state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
        );
      },
    );
  }

  Future<void> submitTwoFactor(String code) async {
    final userName = state.twoFactorUserName;
    if (userName == null || code.isEmpty) return;
    state = state.copyWith(status: LoginStatus.loading, errorMessage: '');
    final result = await ref
        .read(twoFactorUseCaseProvider)
        .call(userName, code);
    result.fold(
      onSuccess: (_) =>
          state = state.copyWith(status: LoginStatus.success, errorMessage: ''),
      onFailure: (failure) => state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  LoginCredentials? _credentials() {
    switch (state.strategy) {
      case LoginStrategy.standard:
        if (state.username.isEmpty || state.password.isEmpty) return null;
        return StandardCredentials(state.username, state.password);
      case LoginStrategy.eo:
        if (state.phone.isEmpty || state.name.isEmpty || state.password.isEmpty)
          return null;
        return EoCredentials(state.phone, state.name, state.password);
      case LoginStrategy.roble:
        final creds = RobleCredentials(
          nit: state.nit,
          placa: state.placa,
          dpi: state.dpi,
        );
        if (!creds.isValid) return null;
        return creds;
    }
  }
}

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
