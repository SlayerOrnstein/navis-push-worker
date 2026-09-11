import 'package:firebase_admin_sdk/messaging.dart';

abstract class MessageBase {
  String get title;
  String get body;
  String get topic;

  Notification get notification => Notification(title: title, body: body);
}
