import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:worldstate_models/worldstate_models.dart';

class CambionHandler extends MessageHandler {
  CambionHandler(this.cambion);

  final CambionCycle cambion;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    final activation = await cache.get(cambion.id);
    if (activation != null) return;

    final message = CambionMessage(cambion);

    await send(message.topic, message.notification);
    await cache.set(key: cambion.id, value: cambion.activation);
  }
}
