import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/utils.dart';
import 'package:warframestat_client/warframestat_client.dart';

class BaroHandler extends MessageHandler {
  BaroHandler(this.trader);

  final Trader trader;

  @override
  Future<void> notify() async {
    final key = cacheKey(platform, NotificationKeys.baroKey);
    final ids = cache.getAllIds(key);
    final now = DateTime.now();

    final diffInMinutes = trader.expiry.difference(now).inMinutes;
    final isLeaving = diffInMinutes >= 58 && diffInMinutes <= 60;

    if (ids.contains(trader.id) && !isLeaving) return;

    final hasArrived = trader.active &&
        trader.activation.difference(now) < const Duration(minutes: 2);

    if (hasArrived || isLeaving) {
      final status = trader.active ? 'has arrived' : 'is leaving soon';
      final notification = Notification()
        ..title = 'Baro has Arrived'
        ..body = "Baro Ki'Teer $status";

      await auth.send(NotificationKeys.baroKey, notification);
      cache.addId(key, ids..add(trader.id));
    }
  }
}
