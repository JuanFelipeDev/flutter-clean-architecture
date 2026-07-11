/// Security service seams. Native implementations (`local_auth`,
/// `flutter_jailbreak_detection`, platform channels for signature verify) land
/// in Phase 4. These interfaces keep `core/` consumable and testable now.
library;

import '../config/flavor_config.dart';

/// Result of a root/jailbreak check (AFILIADO `RootBeer` /
/// `presentation/security_root`).
enum RootStatus { secure, rooted, unknown }

abstract class RootDetectionService {
  Future<RootStatus> check();
}

abstract class BiometricService {
  Future<bool> isAvailable();
  Future<bool> authenticate({String reason = ''});
}

/// Certificate pinning configuration per flavor (PRESTADOR
/// `getCertificatedPin`).
abstract class CertificatePinningService {
  List<String> pinsFor(FlavorConfig flavor);
}

/// Android APK signature verification (AFILIADO `AppSignatures`, release only).
abstract class SignatureVerifyService {
  Future<bool> verify();
}

// -- Phase 3 no-op implementations ---------------------------------------

class NoopRootDetection implements RootDetectionService {
  @override
  Future<RootStatus> check() async => RootStatus.secure;
}

class NoopBiometricService implements BiometricService {
  @override
  Future<bool> isAvailable() async => false;
  @override
  Future<bool> authenticate({String reason = ''}) async => false;
}

class NoopCertificatePinning implements CertificatePinningService {
  @override
  List<String> pinsFor(FlavorConfig flavor) => const <String>[];
}

class NoopSignatureVerify implements SignatureVerifyService {
  @override
  Future<bool> verify() async => true;
}