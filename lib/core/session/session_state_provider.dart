/// Authentication state used by route guards. Seeded during [bootstrap] after
/// checking secure storage for a persisted session (AFILIADO `OpenApp`
/// token-vs-login decision).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// True when a valid session is available in secure storage.
final isAuthenticatedProvider = StateProvider<bool>((ref) => false);