import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

class CetusHandler extends MessageHandler {
  CetusHandler(this.cetus);

  final CetusCycle cetus;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    final activation = await cache.get(cetus.id);
    if (activation != null) return;

    final message = CetusMessage(cetus);

    await send(message.topic, message.notification);
    await cache.set(key: cetus.id, value: cetus.activation);
  }
}
