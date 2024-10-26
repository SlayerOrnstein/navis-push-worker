import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:navis_push_worker/src/utils.dart';
import 'package:warframestat_client/warframestat_client.dart';

class InvasionMessage extends MessageBase {
  InvasionMessage(this.invasion, {this.isDefending = true});

  final Invasion invasion;
  final bool isDefending;

  InvasionFaction get _invasionFaction =>
      isDefending ? invasion.defender : invasion.attacker;

  @override
  String get topic {
    final rewardType = _invasionFaction.reward?.countedItems.first.type;

    return getResourceKey(rewardType ?? '') ?? '';
  }

  @override
  String get title => invasion.node;

  @override
  String get body {
    final opposingFaction =
        isDefending ? invasion.attacker.faction : invasion.defender.faction;

    final reward = isDefending
        ? invasion.defender.reward!.itemString
        : invasion.attacker.reward!.itemString;

    return '${_invasionFaction.faction} is rewarding $reward to those who help '
        '${isDefending ? 'defend against' : 'attack'} the $opposingFaction';
  }
}
