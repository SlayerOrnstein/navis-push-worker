import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:navis_push_worker/src/utils.dart';
import 'package:worldstate_models/worldstate_models.dart';

class Invasionhandler extends MessageHandler {
  Invasionhandler(this.invasions);

  final List<Invasion> invasions;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    for (final invasion in invasions.where((i) => i.isActive)) {
      final activation = await cache.get(invasion.id);
      if (activation != null) continue;

      final dTopic = getResourceKey(invasion.defender.reward!.countedItems!.first.key);
      if (dTopic != null) {
        final defender = InvasionMessage(invasion);
        await send(dTopic, defender.notification);
      }

      if (!invasion.vsInfestation) {
        final aTopic = getResourceKey(invasion.attacker.reward!.countedItems!.first.key);
        if (aTopic != null) {
          final attacker = InvasionMessage(invasion, isDefending: false);
          await send(aTopic, attacker.notification);
        }
      }

      await cache.set(key: invasion.id, value: invasion.activation);
    }
  }
}
