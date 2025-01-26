import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/messages.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

class DarvoDealHandler extends MessageHandler {
  DarvoDealHandler(this.darvoDeals);

  final List<DailyDeal> darvoDeals;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    for (final deal in darvoDeals) {
      final activation = await cache.get(deal.id);
      if (activation != null) continue;

      final message = DarvoMessage(deal);

      await send(message.topic, message.notification);
      await cache.set(key: deal.id, value: deal.activation);
    }
  }
}
