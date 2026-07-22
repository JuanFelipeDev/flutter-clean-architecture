/// `UploadProgressInterceptor`). Emits a typed [UploadProgress] stream that
/// UI can subscribe to.
library;

import 'dart:async';

import 'package:dio/dio.dart';

class UploadProgress {
  const UploadProgress({required this.sent, required this.total});
  final int sent;
  final int total;

  double? get fraction => total > 0 ? sent / total : null;
}

class UploadProgressInterceptor extends Interceptor {
  UploadProgressInterceptor(this._sink);

  final StreamController<UploadProgress> _sink;
  Stream<UploadProgress> get progress => _sink.stream;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() == 'POST' ||
        options.method.toUpperCase() == 'PUT') {
      options.onSendProgress = (sent, total) {
        if (!_sink.isClosed)
          _sink.add(UploadProgress(sent: sent, total: total));
      };
    }
    handler.next(options);
  }

  void dispose() => _sink.close();
}
