import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/utils.dart';
import 'package:warframestat_client/warframestat_client.dart';

class DarvoDealHandler extends MessageHandler {
  DarvoDealHandler(this.darvoDeals);

  final List<DailyDeal> darvoDeals;

  static const _title = 'Darvo Deal';
  static const _preNotify = Duration(minutes: 5);

  @override
  Future<void> notify() async {
    final key = cacheKey(platform, NotificationKeys.darvoKey);
    final ids = cache.getAllIds(key);

    final now = DateTime.now();

    for (final darvoDeal in darvoDeals) {
      if (ids.contains(darvoDeal.id) ||
          darvoDeal.activation.difference(now) <= _preNotify) continue;

      final notification = Notification()
        ..title = _title
        ..body = '${darvoDeal.item} is on sale for ${darvoDeal.discount}% off '
            "or ${darvoDeal.salePrice}p if you don't want to do the math";

      await auth.send(NotificationKeys.darvoKey, notification);
      cache.addId(key, ids..add(darvoDeal.id));
    }
  }
}
