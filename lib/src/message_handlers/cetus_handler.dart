import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:warframestat_client/warframestat_client.dart';

class CetusHandler extends MessageHandler {
  CetusHandler(this.cetus, super.auth, super.cache);

  final CetusCycle cetus;

  @override
  Future<void> notify() async {
    const dayText =
        'It will be day on Cetus soon, do you hear thumping in the distance?';
    const nightText = 'Get ready Tenno the Eidolons are waking up soon';

    final topic =
        cetus.isDay ? NotificationKeys.dayKey : NotificationKeys.nightKey;

    final key = topic;
    final ids = cache.getAllIds(key);
    final notification = Notification(
      title: 'Cetus Cycle',
      body: cetus.isDay ? dayText : nightText,
    );

    if (!ids.contains(cetus.id) && recurringEventLimiter(cetus.activation)) {
      await auth.send(topic, notification);
      cache.addId(key, ids..add(cetus.id));
    }
  }
}
