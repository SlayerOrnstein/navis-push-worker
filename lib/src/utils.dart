import 'package:collection/collection.dart';
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
  MessageLayout({required this.notification, this.topic});

  final String? topic;
  final Notification notification;
}
