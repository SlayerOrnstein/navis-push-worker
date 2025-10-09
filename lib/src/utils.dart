import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:shorebird_redis_client/shorebird_redis_client.dart';

String? getResourceKey(String? value) {
  if (value == null) return null;

  return NotificationKeys.resources.keys.firstWhereOrNull(
    (k) {
      return value.toLowerCase().contains(
        NotificationKeys.resources[k]!.toLowerCase(),
      );
    },
  );
}

Credential getServiceAccount() {
  final serviceAccountEnv = Platform.environment['SERVICE_ACCOUNT'];
  if (serviceAccountEnv == null) {
    throw Exception('SERVICE_ACCOUNT not provided');
  }

  final serviceAccount =
      json.decode(utf8.decode(base64.decode(serviceAccountEnv)))
          as Map<String, dynamic>;

  return Credential.fromServiceAccountParams(
    clientId: serviceAccount['client_id'] as String,
    privateKey: serviceAccount['private_key'] as String,
    email: serviceAccount['client_email'] as String,
  );
}

class RedisMasonLogger implements RedisLogger {
  final _logger = Logger(level: Level.verbose);

  @override
  void debug(String message) => _logger.detail(message);

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.err(message);
  }

  @override
  void info(String message) => _logger.info(message);
}
