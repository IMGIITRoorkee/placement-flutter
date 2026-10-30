import 'package:flutter/foundation.dart';

/// Logs [message] only in debug builds. Never pass credentials, tokens,
/// or raw request/response bodies here — use it for status/flow diagnostics only.
void debugLog(Object? message) {
  if (kDebugMode) {
    // ignore: avoid_print
    print(message);
  }
}
