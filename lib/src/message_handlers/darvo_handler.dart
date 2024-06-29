import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:warframestat_client/warframestat_client.dart';

class DarvoDealHandler extends MessageHandler {
  DarvoDealHandler(this.darvoDeals, super.auth, super.cache);

  final List<DailyDeal> darvoDeals;

  @override
  Future<void> notify() async {
    const key = NotificationKeys.darvoKey;
    final ids = cache.getAllIds(key);

    for (final darvoDeal in darvoDeals) {
      if (ids.contains(darvoDeal.id) ||
          recurringEventLimiter(darvoDeal.activation)) continue;

      final notification = Notification(
        title: 'Darvo Deal',
        body: '${darvoDeal.item} is on sale for ${darvoDeal.discount}% off '
            "or ${darvoDeal.salePrice}p if you don't want to do the math",
      );

      await auth.send(NotificationKeys.darvoKey, notification);
      cache.addId(key, ids..add(darvoDeal.id));
    }
  }
}
