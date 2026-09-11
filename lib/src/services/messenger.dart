import 'package:firebase_admin_sdk/firebase_admin_sdk.dart';
import 'package:firebase_admin_sdk/messaging.dart';
import 'package:logger/logger.dart';

class FirebaseMessenger {
  new({required FirebaseApp app, required this._logger}) : _messaging = app.messaging();

  final Messaging _messaging;
  final Logger _logger;

  Future<void> send(String topic, Notification notification) async {
    if (topic.isEmpty) {
      _logger.w('Topic empty not sending message for ${notification.title}');
    }

    final androidConfig = AndroidConfig(
      priority: AndroidConfigPriority.high,
      notification: AndroidNotification(icon: 'ic_notification'),
    );

    final topicMessage = TopicMessage(
      topic: topic,
      notification: notification,
      android: androidConfig,
      data: <String, String>{'click_action': 'FLUTTER_NOTIFICATION_CLICK'},
    );

    try {
      await _messaging.send(topicMessage);
      _logger.i('successfully pushed message for $topic');
    } on Exception catch (e, stack) {
      _logger.e('failed push to $topic', error: e, stackTrace: stack);
    }
  }
}
