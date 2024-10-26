import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/sortie_message.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

class SortieHandler extends MessageHandler {
  SortieHandler(this.sortie);

  final Sortie sortie;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    final activation = await cache.get(sortie.id);
    if (activation != null) return;

    final message = SortieMessage(sortie);
    await send(message.topic, message.notification);

    await cache.set(
      key: sortie.id,
      value: sortie.activation,
      expiry: sortie.expiry,
    );
  }
}
