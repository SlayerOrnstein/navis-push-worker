import 'package:dart_firebase_admin/messaging.dart';

abstract class MessageBase {
  String get title;
  String get body;
  String get topic;

  Notification get notification => Notification(title: title, body: body);
}
