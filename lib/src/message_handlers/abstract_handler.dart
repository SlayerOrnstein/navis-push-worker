import 'package:navis_push_worker/services.dart';

abstract class MessageHandler {
  const MessageHandler(this.auth, this.cache);

  final FirebaseMessenger auth;
  final MessageIdCache cache;

  Future<void> notify();
}
