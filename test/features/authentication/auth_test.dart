import 'package:affiliate_app/core/config/config_providers.dart';
import 'package:affiliate_app/core/config/flavor_config.dart';
import 'package:affiliate_app/core/error/failures.dart';
import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/features/authentication/data/models/login_session_dto.dart';
import 'package:affiliate_app/features/authentication/domain/entities/login_entities.dart';
import 'package:affiliate_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:affiliate_app/features/authentication/presentation/providers/auth_providers.dart';
import 'package:affiliate_app/features/authentication/presentation/states/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this._session);
  final LoginSession _session;

  @override
  Future<Result<LoginSession>> login(LoginCredentials credentials, {String? deviceToken}) async {
    if (credentials is RobleCredentials && !credentials.isValid) {
      return Err(Failure.validation('Complete at least two fields'));
    }
    return Success(_session);
  }

  @override
  Future<Result<LoginSession>> verifyTwoFactor(String userName, String code) async {
    return Success(_session);
  }

  @override
  Future<void> logout() async {}
}

void main() {
  group('LoginSession', () {
    test('requires 2FA when user is null but userName present', () {
      const session = LoginSession(accessToken: '', userName: 'bob');
      expect(session.requiresTwoFactor, isTrue);
    });

    test('does not require 2FA when user present', () {
      const session = LoginSession(
        accessToken: 'token',
        user: AffiliateUser(id: '1', userName: 'bob'),
      );
      expect(session.requiresTwoFactor, isFalse);
    });
  });

  group('LoginSessionMapper', () {
    test('maps access + user, detects 2FA when user missing', () {
      const dto = LoginSessionDto(access: 'tok', userName: 'bob');
      const mapper = LoginSessionMapper();
      final entity = mapper.toEntity(dto);
      expect(entity.accessToken, 'tok');
      expect(entity.requiresTwoFactor, isTrue);
    });

    test('maps full session with user', () {
      const dto = LoginSessionDto(
        access: 'tok',
        refresh: 'ref',
        userName: 'bob',
        cltId: '42',
        affKey: 'aff-1',
        user: {'id': '1', 'userName': 'bob'},
      );
      const mapper = LoginSessionMapper();
      final entity = mapper.toEntity(dto);
      expect(entity.requiresTwoFactor, isFalse);
      expect(entity.clientId, '42');
      expect(entity.user?.id, '1');
    });
  });

  group('RobleCredentials', () {
    test('valid when at least two fields filled', () {
      expect(const RobleCredentials(nit: '1', placa: 'A').isValid, isTrue);
    });
    test('invalid when fewer than two filled', () {
      expect(const RobleCredentials(nit: '1').isValid, isFalse);
    });
  });

  group('LoginNotifier', () {
    test('builds standard credentials and submits', () async {
      final container = ProviderContainer(overrides: [
        flavorConfigProvider.overrideWithValue(
          const FlavorConfig(
            flavor: Flavor.basenewsoa,
            environment: Environment.dev,
            appName: 'Test',
            primaryColor: 0xFF000000,
            accentColor: 0xFF000000,
            loginStrategy: LoginStrategy.standard,
            registerFields: [],
            clientId: '',
            country: '',
            urlServerDev: '',
            urlServerQa: '',
            urlServerProd: '',
            urlServerPreprod: '',
            urlSocket: '',
            socketPath: '',
            sentryDsn: '',
            mapsApiKey: '',
          ),
        ),
        authRepositoryProvider.overrideWithValue(
          _FakeAuthRepository(const LoginSession(
            accessToken: 'tok',
            user: AffiliateUser(id: '1', userName: 'bob'),
          )),
        ),
      ]);

      addTearDown(container.dispose);
      final notifier = container.read(loginProvider.notifier);
      notifier.setField('username', 'bob');
      notifier.setField('password', 'pass');
      await notifier.submit();

      expect(container.read(loginProvider).status, LoginStatus.success);
    });

    test('fails on incomplete standard credentials', () async {
      final container = ProviderContainer(overrides: [
        flavorConfigProvider.overrideWithValue(
          const FlavorConfig(
            flavor: Flavor.basenewsoa,
            environment: Environment.dev,
            appName: 'Test',
            primaryColor: 0xFF000000,
            accentColor: 0xFF000000,
            loginStrategy: LoginStrategy.standard,
            registerFields: [],
            clientId: '',
            country: '',
            urlServerDev: '',
            urlServerQa: '',
            urlServerProd: '',
            urlServerPreprod: '',
            urlSocket: '',
            socketPath: '',
            sentryDsn: '',
            mapsApiKey: '',
          ),
        ),
        authRepositoryProvider.overrideWithValue(
          _FakeAuthRepository(const LoginSession(accessToken: 'tok')),
        ),
      ]);
      addTearDown(container.dispose);
      final notifier = container.read(loginProvider.notifier);
      await notifier.submit();
      expect(container.read(loginProvider).status, LoginStatus.failure);
    });
  });
}