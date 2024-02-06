import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/utils.dart';
import 'package:warframestat_client/warframestat_client.dart';

class CambionHandler extends MessageHandler {
  CambionHandler(this.cambion);

  final CambionCycle cambion;

  static const _preNotify = Duration(minutes: 10);

  @override
  Future<void> notify() async {
    final topic = cambion.state == CambionState.fass
        ? NotificationKeys.fassKey
        : NotificationKeys.vomeKey;

    final key = cacheKey(platform, topic);
    final ids = cache.getAllIds(key);
    final now = DateTime.now();

    final cycle = Notification()
      ..title = 'Cambion Cycle'
      ..body = 'It will be fass on Cambion soon';

    if (!ids.contains(cambion.id) &&
        cambion.expiry.difference(now) <= _preNotify) {
      await auth.send(topic, cycle);
      cache.addId(key, ids..add(cambion.id));
    }
  }
}
