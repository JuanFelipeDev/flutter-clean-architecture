/// Riverpod providers for security services. Phase 3 no-ops; Phase 4 overrides
/// with native implementations.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'security_services.dart';

final rootDetectionProvider = Provider<RootDetectionService>((ref) {
  return NoopRootDetection();
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return NoopBiometricService();
});

final certificatePinningProvider = Provider<CertificatePinningService>((ref) {
  return NoopCertificatePinning();
});

final signatureVerifyProvider = Provider<SignatureVerifyService>((ref) {
  return NoopSignatureVerify();
});