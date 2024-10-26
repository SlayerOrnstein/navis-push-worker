import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

class AlertHandler extends MessageHandler {
  AlertHandler(this.alerts);

  final List<Alert> alerts;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    for (final alert in alerts) {
      final activation = await cache.get(alert.id);
      if (activation != null) continue;

      final message = AlertMessage(alert);

      await send(message.topic, message.notification);
      await cache.set(
        key: alert.id,
        value: alert.activation,
        expiry: alert.expiry,
      );
    }
  }
}
