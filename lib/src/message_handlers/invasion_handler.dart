import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/utils.dart';
import 'package:warframestat_client/warframestat_client.dart';

class Invasionhandler extends MessageHandler {
  Invasionhandler(this.invasions);

  final List<Invasion> invasions;

  MessageLayout _invasionBuilder({
    required String node,
    required String faction,
    required String opposingFaction,
    required String reward,
    required String rewardType,
    bool defending = false,
  }) {
    final notification = Notification()
      ..title = node
      ..body = '$faction is rewarding $reward to those who help '
          '${defending ? 'defend against' : 'attack'} the $opposingFaction';

    return MessageLayout(
      topic: getResourceKey(rewardType),
      notification: notification,
    );
  }

  @override
  Future<void> notify() async {
    for (final invasion in invasions) {
      const key = 'invasions';
      final ids = cache.getAllIds(key);

      if (ids.contains(invasion.id)) continue;

      final attacker = invasion.vsInfestation
          ? null
          : _invasionBuilder(
              node: invasion.node,
              faction: invasion.attackingFaction,
              opposingFaction: invasion.defendingFaction,
              reward: invasion.attackerReward.itemString,
              rewardType: invasion.attackerReward.countedItems.first.type,
            );

      final defender = _invasionBuilder(
        node: invasion.node,
        faction: invasion.defendingFaction,
        opposingFaction: invasion.attackingFaction,
        reward: invasion.defenderReward.itemString,
        rewardType: invasion.defenderReward.countedItems.first.type,
        defending: true,
      );

      await auth.send(attacker?.topic, attacker?.notification);
      await auth.send(defender.topic, defender.notification);
      cache.addId(key, ids..add(invasion.id));
    }
  }
}
