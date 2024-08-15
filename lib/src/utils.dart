import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';

String? getResourceKey(String value) {
  return NotificationKeys.resources.keys.firstWhereOrNull(
    (k) {
      return value
          .toLowerCase()
          .contains(NotificationKeys.resources[k]!.toLowerCase());
    },
  );
}

class MessageLayout {
  MessageLayout({required this.topic, required this.notification});

  final String topic;
  final Notification notification;
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
