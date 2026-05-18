import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:worldstate_models/worldstate_models.dart';

class FissureMessage extends MessageBase {
  FissureMessage(this.fissure);

  final VoidFissure fissure;

  @override
  String get body => '${fissure.node} - ${fissure.missionType} - ${fissure.faction}';

  @override
  String get topic {
    final name = fissure.tier.name;
    final tier = name.substring(0, 1).toUpperCase() + name.substring(1);
    final mission = fissure.missionType.replaceAll(' ', '_').toLowerCase();

    return '$tier.$mission';
  }

  @override
  String get title {
    if (fissure.isSteelpath) return '${fissure.tier} - Steel Path';
    if (fissure.isStorm) return '${fissure.tier} - Void Storm';

    return '${fissure.tier} Fissure';
  }
}
