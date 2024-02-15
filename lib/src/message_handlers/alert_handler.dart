import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:warframestat_client/warframestat_client.dart';

class AlertHandler extends MessageHandler {
  AlertHandler(this.alerts);

  final List<Alert> alerts;

  @override
  Future<void> notify() async {
    const key = NotificationKeys.alertsKey;
    final ids = cache.getAllIds(key);

    for (final alert in alerts) {
      if (ids.contains(alert.id) || recurringEventLimiter(alert.activation)) {
        continue;
      }

      final notification = Notification()
        ..title = alert.mission.node
        ..body = '${alert.mission.type}(${alert.mission.faction})'
            ' | ${alert.mission.minEnemyLevel} - '
            '${alert.mission.maxEnemyLevel} |'
            ' | ${alert.mission.reward!.itemString}';

      await auth.send(NotificationKeys.alertsKey, notification);
      cache.addId(key, ids..add(alert.id));
    }
  }
}
