import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

class EarthHandler extends MessageHandler {
  EarthHandler(this.earth);

  final EarthCycle earth;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    final activation = await cache.get(earth.id);
    if (activation != null) return;

    final message = EarthMessage(earth);

    await send(message.topic, message.notification);
    await cache.set(key: earth.id, value: earth.activation);
  }
}
