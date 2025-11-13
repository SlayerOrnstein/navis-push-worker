import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/messaging.dart';
import 'package:logger/logger.dart';

class FirebaseMessenger {
  FirebaseMessenger({required FirebaseAdminApp admin, required Logger logger})
    : _messaging = Messaging(admin),
      _logger = logger;

  final Messaging _messaging;
  final Logger _logger;

  Future<void> send(String topic, Notification notification) async {
    final androidConfig = AndroidConfig(
      priority: AndroidConfigPriority.high,
      notification: AndroidNotification(icon: 'ic_notification'),
    );

    final topicMessage = TopicMessage(
      topic: topic,
      notification: notification,
      android: androidConfig,
      data: <String, String>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      },
    );

    try {
      await _messaging.send(topicMessage);
      _logger.i('successfully pushed message for $topic');
    } on Exception catch (e, stack) {
      _logger.e('failed push to $topic', error: e, stackTrace: stack);
    }
  }
}
