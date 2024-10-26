import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:warframestat_client/warframestat_client.dart';

class FissureMessage extends MessageBase {
  FissureMessage(this.fissure);

  final Fissure fissure;

  @override
  String get body =>
      '${fissure.node} - ${fissure.missionType} - ${fissure.enemy}';

  @override
  String get topic {
    return '${fissure.tier}.'
        '${fissure.missionType.replaceAll(' ', '_').toLowerCase()}';
  }

  @override
  String get title {
    if (fissure.isHard) return '${fissure.tier} - Steel Path';
    if (fissure.isStorm) return '${fissure.tier} - Void Storm';

    return '${fissure.tier} Fissure';
  }
}
