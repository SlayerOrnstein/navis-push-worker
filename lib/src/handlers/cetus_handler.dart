import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:worldstate_models/worldstate_models.dart';

class CetusHandler extends MessageHandler {
  CetusHandler(this.cetus);

  final CetusCycle cetus;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    final activation = await cache.get(cetus.id);
    if (activation != null) return;

    final cetusMessage = CetusMessage(cetus);
    final earthMessage = EarthMessage(cetus);

    await send(cetusMessage.topic, cetusMessage.notification);
    await send(earthMessage.topic, earthMessage.notification);
    await cache.set(key: cetus.id, value: cetus.activation);
  }
}
