import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:warframestat_client/warframestat_client.dart';

class EarthHandler extends MessageHandler {
  EarthHandler(this.earth, super.auth, super.cache);

  final EarthCycle earth;

  @override
  Future<void> notify() async {
    final topic = earth.isDay
        ? NotificationKeys.earthDayKey
        : NotificationKeys.earthNightKey;

    final key = topic;
    final ids = cache.getAllIds(key);
    if (ids.contains(earth.id)) return;

    final notification = Notification(
      title: 'Earth Cycle',
      body: 'It is now ${earth.isDay ? 'day' : 'night'} on earth',
    );

    await auth.send(topic, notification);
    cache.addId(key, ids..add(earth.id));
  }
}
