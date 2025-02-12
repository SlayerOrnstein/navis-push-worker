import 'package:navis_push_worker/navis_push_worker.dart';
import 'package:warframestat_client/warframestat_client.dart';

class OperationAlertMessage extends MessageBase {
  OperationAlertMessage(this.event, this.alert);

  final Alert alert;
  final WorldEvent event;

  @override
  String get body {
    final mission = alert.mission;

    return '${mission.node} - ${mission.faction}\n${mission.type}'
        'Level ${alert.mission.minEnemyLevel} - ${alert.mission.maxEnemyLevel}'
        '\n${alert.mission.reward!.itemString}';
  }

  @override
  String get title => event.description;

  @override
  String get topic => NotificationKeys.operationAlertsKey;
}
