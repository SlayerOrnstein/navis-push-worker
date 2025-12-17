import 'package:collection/collection.dart';
import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:worldstate_models/worldstate_models.dart';

class AlertHandler extends MessageHandler {
  AlertHandler(this.events, this.alerts);

  final List<WorldEvent> events;
  final List<Alert> alerts;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    for (final alert in alerts.where((i) => i.isActive)) {
      final activation = await cache.get(alert.id);
      if (activation != null) continue;

      final operation = events.firstWhereOrNull((e) => e.tag == alert.tag);
      MessageBase message = AlertMessage(alert);
      if (operation != null) {
        message = OperationAlertMessage(operation, alert);
      }

      await send(message.topic, message.notification);
      await cache.set(key: alert.id, value: alert.activation);
    }
  }
}
