import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/core/session/session_repository.dart';
import 'package:affiliate_app/features/splash/data/mappers/version_check_mapper.dart';
import 'package:affiliate_app/features/splash/data/models/version_check_dto.dart';
import 'package:affiliate_app/features/splash/domain/entities/splash_entities.dart';
import 'package:affiliate_app/features/splash/domain/usecases/decide_initial_route_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSessionRepository implements SessionRepository {
  _FakeSessionRepository(this._hasSession);
  final bool _hasSession;

  @override
  Future<bool> hasSession() async => _hasSession;
  @override
  Future<void> clear() async {}
  @override
  Future<String?> accessToken() async => null;
  @override
  Future<Result<void>> refresh() async => Result<void>.guard(() {});
}

void main() {
  group('VersionCheck', () {
    test('detects newer published version', () {
      const check = VersionCheck(
        currentVersion: '1.0.0',
        latestVersion: '1.2.0',
      );
      expect(check.isOutdated, isTrue);
    });

    test('not outdated when versions equal', () {
      const check = VersionCheck(
        currentVersion: '1.0.0',
        latestVersion: '1.0.0',
      );
      expect(check.isOutdated, isFalse);
    });

    test('force update flag overrides comparison', () {
      const check = VersionCheck(
        currentVersion: '2.0.0',
        latestVersion: '1.0.0',
        updateRequired: true,
      );
      expect(check.isOutdated, isTrue);
    });
  });

  group('VersionCheckMapper', () {
    test('maps DTO version + force_update state', () {
      const dto = VersionCheckDto(vaVersion: '1.5.0', vaState: 'force_update');
      const mapper = VersionCheckMapper();
      final entity = mapper.toEntity(dto, currentVersion: '1.0.0');
      expect(entity.latestVersion, '1.5.0');
      expect(entity.updateRequired, isTrue);
      expect(entity.isOutdated, isTrue);
    });
  });

  group('DecideInitialRouteUseCase', () {
    test('routes to home when a session exists', () async {
      final useCase = DecideInitialRouteUseCase(_FakeSessionRepository(true));
      final route = await useCase.call();
      expect(route, isA<HomeRoute>());
    });

    test('routes to login when no session', () async {
      final useCase = DecideInitialRouteUseCase(_FakeSessionRepository(false));
      final route = await useCase.call();
      expect(route, isA<LoginRoute>());
    });

    test('routes to deep-link login when card id provided', () async {
      final useCase = DecideInitialRouteUseCase(_FakeSessionRepository(false));
      final route = await useCase.call(deepLinkCardId: 'ABC123');
      expect(route, isA<DeepLinkLoginRoute>());
      expect((route as DeepLinkLoginRoute).cardId, 'ABC123');
    });
  });
}
