import 'package:navis_push_worker/services.dart';

abstract class MessageHandler {
  Auth get auth => locator<Auth>();

  MessageIdCache get cache => locator<MessageIdCache>();

  Future<void> notify();
}
