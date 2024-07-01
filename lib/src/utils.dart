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
  final serviceAccount = File('./service_account.json');
  if (!serviceAccount.existsSync()) {
    throw Exception('SERVICE_ACCOUNT not provided');
  }

  return Credential.fromServiceAccount(serviceAccount);
}
