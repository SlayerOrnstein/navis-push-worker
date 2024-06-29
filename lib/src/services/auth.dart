import 'dart:convert';
import 'dart:io';

import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/messaging.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:mason_logger/mason_logger.dart';

const scopes = <String>['https://www.googleapis.com/auth/firebase.messaging'];

class Auth {
  static Auth? _auth;
  static late Messaging _fcm;

  final Logger logger = Logger();

  static Future<Auth> initialize() async {
    _fcm = Messaging(await _authenticate());

    return _auth ??= Auth();
  }

  Future<void> send(String? topic, Notification? notification) async {
    if (topic == null || notification == null) return;

    final androidNotification = AndroidNotification(
      icon: 'ic_notification',
    );

    final androidConfig = AndroidConfig(
      priority: AndroidConfigPriority.high,
      notification: androidNotification,
    );

    // final message = Message
    // ..condition = "'$topic' in topics"
    // ..notification = notification
    // ..android = _androidConfig
    // ..data = <String, String>{'click_action': 'FLUTTER_NOTIFICATION_CLICK'};

    final parent = Platform.environment['FIREBASE_PROJECT'];
    if (parent == null) {
      throw Exception('FIREBASE_PROJECT not provided');
    }

    try {
      var message = '';
      if (Platform.environment['ENVIRONMENT'] == 'production') {
        message = await _fcm.send(
          TopicMessage(
            topic: topic,
            notification: notification,
            android: androidConfig,
            data: <String, String>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
          ),
        );
      }

      logger.success('successfully pushed $message for $topic');
    } catch (e) {
      logger.alert('failed push to $topic');
    }
  }

  static Future<FirebaseAdminApp> _authenticate() async {
    final serviceAccount = Platform.environment['SERVICE_ACCOUNT'];
    if (serviceAccount == null) throw Exception('SERVICE_ACCOUNT not provided');

    final projectId = Platform.environment['FIREBASE_PROJECT'];
    if (projectId == null) throw Exception('FIREBASE_PROJECT not provided');

    final decoded = utf8.decode(base64.decode(serviceAccount));
    final service = ServiceAccountCredentials.fromJson(decoded);

    return FirebaseAdminApp.initializeApp(
      projectId,
      Credential.fromServiceAccountParams(
        clientId: service.clientId.toString(),
        privateKey: service.privateKey,
        email: service.email,
      ),
    );
  }
}
