import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/utils.dart';
import 'package:warframestat_client/warframestat_client.dart';

class Invasionhandler extends MessageHandler {
  Invasionhandler(this.invasions, super.auth, super.cache);

  final List<Invasion> invasions;

  MessageLayout? _invasionBuilder({
    required String node,
    required String faction,
    required String opposingFaction,
    required String reward,
    required String rewardType,
    bool defending = false,
  }) {
    final topic = getResourceKey(rewardType);
    if (topic == null) return null;

    final notification = Notification(
      title: node,
      body: '$faction is rewarding $reward to those who help '
          '${defending ? 'defend against' : 'attack'} the $opposingFaction',
    );

    return MessageLayout(
      topic: topic,
      notification: notification,
    );
  }

  @override
  Future<void> notify() async {
    for (final invasion in invasions) {
      const key = 'invasions';
      final ids = cache.getAllIds(key);

      if (ids.contains(invasion.id)) continue;
      cache.addId(key, ids..add(invasion.id));

      final defender = _invasionBuilder(
        node: invasion.node,
        faction: invasion.defender.faction,
        opposingFaction: invasion.attacker.faction,
        reward: invasion.defender.reward!.itemString,
        rewardType: invasion.defender.reward!.countedItems.first.type,
        defending: true,
      );

      if (defender != null) {
        await auth.send(defender.topic, defender.notification);
      }

      if (invasion.vsInfestation) continue;

      final attacker = _invasionBuilder(
        node: invasion.node,
        faction: invasion.attackingFaction,
        opposingFaction: invasion.defender.faction,
        reward: invasion.attacker.reward!.itemString,
        rewardType: invasion.attacker.reward!.countedItems.first.type,
      );

      if (attacker != null) {
        await auth.send(attacker.topic, attacker.notification);
      }
    }
  }
}
