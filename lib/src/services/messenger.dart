import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/messaging.dart';
import 'package:mason_logger/mason_logger.dart';

class FirebaseMessenger {
  FirebaseMessenger({required FirebaseAdminApp admin, required this.projectId})
      : _messaging = Messaging(admin);

  final Messaging _messaging;
  final String projectId;

  final logger = Logger();

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
      logger.success('successfully pushed message for $topic');
    } on Exception {
      logger.err('failed push to $topic');
    }
  }
}
