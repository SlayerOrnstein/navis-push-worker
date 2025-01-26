import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

class FissuresHandler extends MessageHandler {
  FissuresHandler(this.fissures);

  final List<Fissure> fissures;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    for (final fissure in fissures) {
      final activation = await cache.get(fissure.id);
      if (activation != null) continue;

      final message = FissureMessage(fissure);

      await send(message.topic, message.notification);
      await cache.set(key: fissure.id, value: fissure.activation);
    }
  }
}
