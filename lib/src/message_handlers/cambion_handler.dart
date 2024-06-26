import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:warframestat_client/warframestat_client.dart';

class CambionHandler extends MessageHandler {
  CambionHandler(this.cambion, super.auth, super.cache);

  final CambionCycle cambion;

  @override
  Future<void> notify() async {
    final topic = cambion.state == CambionState.fass
        ? NotificationKeys.fassKey
        : NotificationKeys.vomeKey;

    final key = topic;
    final ids = cache.getAllIds(key);
    final cycle = Notification(
      title: 'Cambion Cycle',
      body: 'It will be fass on Cambion soon',
    );

    if (!ids.contains(cambion.id) && recurringEventLimiter(cambion.expiry)) {
      await auth.send(topic, cycle);
      cache.addId(key, ids..add(cambion.id));
    }
  }
}
