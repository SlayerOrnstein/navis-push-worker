import 'package:navis_push_worker/src/handlers/handlers.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

class DuviriHandler extends MessageHandler {
  DuviriHandler(this.duviriCycle);

  final DuviriCycle duviriCycle;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    final activation = await cache.get(duviriCycle.id);
    if (activation != null) return;

    final message = DuviriMessage(duviriCycle);

    await send(message.topic, message.notification);
    await cache.set(key: duviriCycle.id, value: duviriCycle.activation);
  }
}
