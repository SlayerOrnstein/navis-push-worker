import 'package:navis_push_worker/src/handlers/handlers.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:worldstate_models/worldstate_models.dart';

class ArchonHandler extends MessageHandler {
  ArchonHandler(this.archon);

  final Sortie archon;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    final activation = await cache.get(archon.id);
    if (activation != null) return;

    final archonMessage = ArchonMessage(archon);

    await send(archonMessage.topic, archonMessage.notification);
    await cache.set(key: archon.id, value: archon.activation);
  }
}
