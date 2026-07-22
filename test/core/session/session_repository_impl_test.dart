import 'package:affiliate_app/core/session/auth_api_service.dart';
import 'package:affiliate_app/core/session/session_repository_impl.dart';
import 'package:affiliate_app/core/storage/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

class _FakeAuthApi implements AuthApiService {
  _FakeAuthApi(this._newAccess);
  final String _newAccess;
  int calls = 0;

  @override
  Future<({String access, String? refresh})> refresh(
    String refreshToken,
  ) async {
    calls++;
    return (access: _newAccess, refresh: refreshToken);
  }
}

void main() {
  late _MockSecureStorage mockStorage;
  late SecureStorageService service;
  late _FakeAuthApi authApi;

  setUp(() {
    mockStorage = _MockSecureStorage();
    service = SecureStorageService(storage: mockStorage);
    authApi = _FakeAuthApi('new-access');

    when(
      () => mockStorage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => null);
    when(
      () => mockStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async => ());
    when(
      () => mockStorage.delete(key: any(named: 'key')),
    ).thenAnswer((_) async => ());
  });

  test('refresh succeeds when a refresh token is stored', () async {
    const sessionJson =
        '{"access":"old","refresh":"old-refresh","client_id":"42"}';
    when(
      () => mockStorage.read(key: 'login_data'),
    ).thenAnswer((_) async => sessionJson);
    when(
      () => mockStorage.read(key: 'TOKEN'),
    ).thenAnswer((_) async => 'new-access');

    final repo = SessionRepositoryImpl(storage: service, authApi: authApi);
    final result = await repo.refresh();

    expect(result.isSuccess, isTrue);
    expect(authApi.calls, 1);
    expect(await repo.accessToken(), 'new-access');
  });

  test('refresh fails when no refresh token is stored', () async {
    final repo = SessionRepositoryImpl(storage: service, authApi: authApi);
    final result = await repo.refresh();

    expect(result.isFailure, isTrue);
    expect(authApi.calls, 0);
  });

  test('hasSession reflects stored access token', () async {
    when(
      () => mockStorage.read(key: 'TOKEN'),
    ).thenAnswer((_) async => 'a-token');
    final repo = SessionRepositoryImpl(storage: service, authApi: authApi);
    expect(await repo.hasSession(), isTrue);
  });
}
