import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:navis_push_worker/src/utils.dart';
import 'package:warframestat_client/warframestat_client.dart';

class CetusHandler extends MessageHandler {
  CetusHandler(this.cetus);

  final CetusCycle cetus;

  static const _title = 'Cetus Cycle';
  static const _dayText =
      'It will be day on Cetus soon, do you hear thumping in the distance?';

  static const _nightText = 'Get ready Tenno the Eidolons are waking up soon';

  @override
  Future<void> notify() async {
    final topic =
        !cetus.isDay ? NotificationKeys.dayKey : NotificationKeys.nightKey;

    final key = cacheKey(platform, topic);
    final ids = cache.getAllIds(key);
    final day = Notification()
      ..title = _title
      ..body = _dayText;

    final night = Notification()
      ..title = _title
      ..body = _nightText;

    if (!ids.contains(cetus.id) && recurringEventLimiter(cetus.expiry)) {
      await auth.send(topic, !cetus.isDay ? day : night);
      cache.addId(key, ids..add(cetus.id));
    }
  }
}
