import 'dart:convert';
import 'dart:io';

import 'package:googleapis/fcm/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:navis_push_worker/src/services/service_locator.dart';

const scopes = <String>['https://www.googleapis.com/auth/firebase.messaging'];

class Auth {
  static Auth? _auth;
  static FirebaseCloudMessagingApi? _fcm;

  final Logger logger = locator<Logger>();

  static Future<Auth> initialize() async {
    _fcm ??= FirebaseCloudMessagingApi(await _authenticate());

    return _auth ??= Auth();
  }

  static final _androidNotification = AndroidNotification()
    ..color = '#1565c0ff'
    ..icon = 'ic_nightmare';

  static final _androidConfig = AndroidConfig()
    ..priority = 'HIGH'
    ..notification = _androidNotification;

  Future<void> send(String? topic, Notification? notification) async {
    if (topic == null || notification == null) return;
    logger.info('Sending notification for $topic');

    final message = Message()
      ..condition = "'$topic' in topics"
      ..notification = notification
      ..android = _androidConfig
      ..data = <String, String>{'click_action': 'FLUTTER_NOTIFICATION_CLICK'};

    final parent = Platform.environment['FIREBASE_PROJECT'];
    if (parent == null) {
      throw Exception('FIREBASE_PROJECT not provided');
    }

    try {
      final request = SendMessageRequest()..message = message;

      final enviroment = Platform.environment['ENVIROMENT'];
      if (enviroment == 'production') {
        await _fcm?.projects.messages.send(request, parent);
      }

      logger.success('Sent message for $topic');
    } catch (e) {
      logger.alert('Failed to send message for $topic');
    }
  }

  static Future<Client> _authenticate() async {
    final serviceAccount = Platform.environment['SERVICE_ACCOUNT'];
    if (serviceAccount == null) throw Exception('SERVICE_ACCOUNT not provided');

    final decoded = utf8.decode(base64.decode(serviceAccount));
    final service = ServiceAccountCredentials.fromJson(decoded);

    return clientViaServiceAccount(service, scopes);
  }
}
