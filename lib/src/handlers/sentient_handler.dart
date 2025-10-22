import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/sentient_message.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:worldstate_models/worldstate_models.dart';

class SentientOutpostHandler extends MessageHandler {
  SentientOutpostHandler(this.outpost);

  final SentientOutpost outpost;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    final activation = await cache.get(outpost.id);
    if (activation != null) return;

    final message = SentientMessage(outpost);

    await send(message.topic, message.notification);
    await cache.set(key: outpost.id, value: outpost.activation);
  }
}
