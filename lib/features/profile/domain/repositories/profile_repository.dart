/// Profile repository contract (AFILIADO `get-profile/`, `edit-profile/{affkey}/`,
/// `edit-password/{affkey}/`, document types, companies).
library;

import '../../../../core/error/result.dart';
import '../entities/profile_entities.dart';

abstract class ProfileRepository {
  Future<Result<AffiliateProfile>> getProfile(String affKey);
  Future<Result<AffiliateProfile>> updateProfile(AffiliateProfile profile);
  Future<Result<void>> changePassword(String affKey, PassChange change);
  Future<Result<List<DocumentType>>> documentTypes();
  Future<Result<List<Company>>> companies();
}