import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

class Invasionhandler extends MessageHandler {
  Invasionhandler(this.invasions);

  final List<Invasion> invasions;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    for (final invasion in invasions) {
      final activation = await cache.get(invasion.id);
      if (activation != null) continue;

      final defender = InvasionMessage(invasion);
      await send(defender.topic, defender.notification);

      if (!invasion.vsInfestation) {
        final attacker = InvasionMessage(invasion, isDefending: false);
        await send(attacker.topic, attacker.notification);
      }

      await cache.set(key: invasion.id, value: invasion.activation);
    }
  }
}
