import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/vallis_message.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

class VallisHandler extends MessageHandler {
  VallisHandler(this.vallis);

  final VallisCycle vallis;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    final activation = await cache.get(vallis.id);
    if (activation != null) return;

    final message = VallisMessage(vallis);

    await send(message.topic, message.notification);
    await cache.set(key: vallis.id, value: vallis.activation);
  }
}
