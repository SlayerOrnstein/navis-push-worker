import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:warframestat_client/warframestat_client.dart';

class EarthHandler extends MessageHandler {
  EarthHandler(this.earth);

  final EarthCycle earth;

  static const _title = 'Earth Cycle';

  @override
  Future<void> notify() async {
    final topic = earth.isDay
        ? NotificationKeys.earthDayKey
        : NotificationKeys.earthNightKey;

    final key = topic;
    final ids = cache.getAllIds(key);

    final notification = Notification()
      ..title = _title
      ..body = 'It is now ${earth.isDay ? 'day' : 'night'} on earth';

    if (ids.contains(earth.id) || recurringEventLimiter(earth.activation)) {
      return;
    }

    await auth.send(topic, notification);
    cache.addId(key, ids..add(earth.id));
  }
}
