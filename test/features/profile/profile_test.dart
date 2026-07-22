import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/core/session/session_data.dart';
import 'package:affiliate_app/core/session/session_providers.dart';
import 'package:affiliate_app/features/profile/data/models/profile_dtos.dart';
import 'package:affiliate_app/features/profile/domain/entities/profile_entities.dart';
import 'package:affiliate_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:affiliate_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:affiliate_app/features/profile/presentation/states/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProfileRepository implements ProfileRepository {
  AffiliateProfile? saved;
  PassChange? changed;

  @override
  Future<Result<AffiliateProfile>> getProfile(String affKey) async => Success(
    AffiliateProfile(
      affKey: affKey,
      firstName: 'Jane',
      firstSurname: 'Doe',
      email: 'jane@x.com',
      documentTypeId: '1',
    ),
  );
  @override
  Future<Result<AffiliateProfile>> updateProfile(
    AffiliateProfile profile,
  ) async {
    saved = profile;
    return Success(profile);
  }

  @override
  Future<Result<void>> changePassword(String affKey, PassChange change) async {
    changed = change;
    return Result<void>.guard(() {});
  }

  @override
  Future<Result<List<DocumentType>>> documentTypes() async => const Success([
    DocumentType(id: '1', name: 'CC'),
    DocumentType(id: '2', name: 'NIT'),
  ]);
  @override
  Future<Result<List<Company>>> companies() async =>
      const Success([Company(id: 'c1', name: 'Co')]);
}

void main() {
  const session = SessionData(accessToken: 'tok', affKey: 'aff-1');

  group('ProfileMapper', () {
    const mapper = ProfileMapper();
    test('round-trips profile entity <-> dto', () {
      const profile = AffiliateProfile(
        affKey: 'a',
        firstName: 'J',
        email: 'j@x.com',
      );
      final dto = mapper.toDto(profile);
      final back = mapper.toEntity(dto);
      expect(back.affKey, 'a');
      expect(back.firstName, 'J');
      expect(back.email, 'j@x.com');
    });
    test('maps document type + company', () {
      expect(
        mapper.toDocumentType(const DocumentTypeDto(id: '1', name: 'CC')).name,
        'CC',
      );
      expect(mapper.toCompany(const CompanyDto(id: 'c', name: 'Co')).id, 'c');
    });
  });

  group('ProfileNotifier', () {
    ProviderContainer makeContainer() {
      final repo = _FakeProfileRepository();
      return ProviderContainer(
        overrides: [
          cachedSessionProvider.overrideWith((_) => session),
          profileRepositoryProvider.overrideWithValue(repo),
        ],
      );
    }

    test('loads profile, document types, companies', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(profileProvider.notifier);
      await notifier.load();
      final state = container.read(profileProvider);
      expect(state.profile?.firstName, 'Jane');
      expect(state.documentTypes, hasLength(2));
      expect(state.companies, hasLength(1));
    });

    test('editField mutates the profile and save persists', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(profileProvider.notifier);
      await notifier.load();
      notifier.editField('firstName', 'Janet');
      expect(container.read(profileProvider).profile?.firstName, 'Janet');
      await notifier.save();
      expect(container.read(profileProvider).status, ProfileStatus.success);
    });

    test('changePassword routes to the repository', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(profileProvider.notifier);
      await notifier.load();
      await notifier.changePassword('old', 'new');
      final repo =
          (container.read(profileRepositoryProvider) as dynamic)
              as _FakeProfileRepository;
      expect(repo.changed?.newPassword, 'new');
      expect(container.read(profileProvider).status, ProfileStatus.success);
    });
  });
}
