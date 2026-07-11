/// SMS OTP autofill seam (AFILIADO `MySMSBroadcastReceiver` / SMS Retriever).
/// Phase 4 wires `sms_autofill`; the interface keeps the seam consumable.
library;

abstract class OtpAutofillService {
  /// App signature hash needed by the SMS Retriever API.
  Future<String?> appSignatureHash();

  /// Stream of auto-detected OTP codes.
  Stream<String> get codes;

  /// Starts listening for the next OTP.
  Future<void> start();

  /// Stops listening.
  Future<void> stop();
}

class NoopOtpAutofillService implements OtpAutofillService {
  @override
  Future<String?> appSignatureHash() async => null;
  @override
  Stream<String> get codes => const Stream<String>.empty();
  @override
  Future<void> start() async {}
  @override
  Future<void> stop() async {}
}