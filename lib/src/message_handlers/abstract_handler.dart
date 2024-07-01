import 'package:navis_push_worker/services.dart';
import 'package:navis_push_worker/src/services/messenger.dart';

abstract class MessageHandler {
  const MessageHandler(this.auth, this.cache);

  final FirebaseMessenger auth;
  final MessageIdCache cache;

  Future<void> notify();
}
