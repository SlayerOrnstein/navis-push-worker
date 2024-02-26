import 'package:navis_push_worker/services.dart';

abstract class MessageHandler {
  const MessageHandler(this.auth, this.cache);

  final Auth auth;
  final MessageIdCache cache;

  Future<void> notify();
}
