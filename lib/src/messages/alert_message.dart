import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:warframestat_client/warframestat_client.dart';

class AlertMessage extends MessageBase {
  AlertMessage(this.alert);

  final Alert alert;

  // Tags are found in alert[index].tag.
  static const _operationTags = ['JadeShadows'];

  @override
  String get body {
    return '${alert.mission.type} (${alert.mission.faction})'
        ' | Level ${alert.mission.minEnemyLevel} -'
        ' ${alert.mission.maxEnemyLevel}'
        ' | ${alert.mission.reward!.itemString}';
  }

  @override
  String get topic => _operationTags.contains(alert.tag)
      ? NotificationKeys.operationAlertsKey
      : NotificationKeys.alertsKey;

  @override
  String get title => alert.mission.node;
}
