import 'package:collection/collection.dart';
import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

class AlertHandler extends MessageHandler {
  AlertHandler(this.events, this.alerts);

  final List<WorldEvent> events;
  final List<Alert> alerts;

  // Tags are found in alert[index].tag.
  static const operationTags = ['JadeShadows'];

  WorldEvent? operation(String tag) {
    return events.firstWhereOrNull(
      (i) => i.tag.toLowerCase().contains(tag.toLowerCase()),
    );
  }

  @override
  Future<void> notify(Send send, IdCache cache) async {
    for (final alert in alerts) {
      final activation = await cache.get(alert.id);
      if (activation != null) continue;

      final operation = this.operation(alert.tag ?? '0000');
      MessageBase message = AlertMessage(alert);
      if (operationTags.contains(alert.tag) && operation != null) {
        message = OperationAlertMessage(operation, alert);
      }

      await send(message.topic, message.notification);
      await cache.set(key: alert.id, value: alert.activation);
    }
  }
}
