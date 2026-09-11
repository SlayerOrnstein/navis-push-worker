import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:firebase_admin_sdk/firebase_admin_sdk.dart';
import 'package:logger/logger.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:shorebird_redis_client/shorebird_redis_client.dart';

String? getResourceKey(String? value) {
  if (value == null) return null;

  return NotificationKeys.resources.keys.firstWhereOrNull((k) {
    return value.toLowerCase().contains(NotificationKeys.resources[k]!.toLowerCase());
  });
}

Credential getServiceAccount() {
  final serviceAccountEnv = Platform.environment['SERVICE_ACCOUNT'];
  if (serviceAccountEnv == null) {
    throw Exception('SERVICE_ACCOUNT not provided');
  }

  final serviceAccount = json.decode(utf8.decode(base64.decode(serviceAccountEnv))) as Map<String, dynamic>;

  return Credential.fromServiceAccountParams(
    projectId: serviceAccount['project_id'] as String,
    clientId: serviceAccount['client_id'] as String,
    privateKey: serviceAccount['private_key'] as String,
    email: serviceAccount['client_email'] as String,
  );
}

class RedisCustomLogger(final Logger _logger) implements RedisLogger {
  @override
  void debug(String message) => _logger.i(message);

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  @override
  void info(String message) => _logger.i(message);
}
