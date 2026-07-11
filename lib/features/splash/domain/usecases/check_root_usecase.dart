/// Checks whether the device is rooted/jailbroken (AFILIADO `RootBeer`,
/// release-gated). Returns `true` when insecure.
library;

import '../../../../core/error/result.dart';
import '../../../../core/security/security_services.dart';

class CheckRootUseCase {
  CheckRootUseCase(this._rootDetection);
  final RootDetectionService _rootDetection;

  Future<Result<bool>> call() async {
    return Result.guardAsync(() async {
      final status = await _rootDetection.check();
      return status == RootStatus.rooted;
    });
  }
}