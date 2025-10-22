import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:worldstate_models/worldstate_models.dart';

class AlertMessage extends MessageBase {
  AlertMessage(this.alert);

  final Alert alert;

  @override
  String get body {
    return '${alert.mission.type} (${alert.mission.faction})'
        ' | Level ${alert.mission.minEnemyLevel} -'
        ' ${alert.mission.maxEnemyLevel}'
        ' | ${alert.mission.reward.itemString}';
  }

  @override
  String get topic => NotificationKeys.alertsKey;

  @override
  String get title => alert.mission.node;
}
