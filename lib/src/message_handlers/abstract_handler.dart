import 'package:navis_push_worker/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

abstract class MessageHandler {
  GamePlatform platform = GamePlatform.pc;

  Auth get auth => locator<Auth>();

  MessageIdCache get cache => locator<MessageIdCache>();

  Future<void> notify();
}
