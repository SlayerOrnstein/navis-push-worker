import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

class BaroHandler extends MessageHandler {
  BaroHandler(this.traders);

  final List<Trader> traders;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    for (final trader in traders) {
      final activation = await cache.get(trader.id);
      if (activation != null) continue;

      final message = BaroMessage(trader);

      await send(message.topic, message.notification);
      await cache.set(
        key: trader.id,
        value: trader.activation,
        expiry: trader.expiry,
      );
    }
  }
}
