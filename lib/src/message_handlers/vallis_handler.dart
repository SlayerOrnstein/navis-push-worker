import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:warframestat_client/warframestat_client.dart';

class VallisHandler extends MessageHandler {
  VallisHandler(this.vallis, super.auth, super.cache);

  final VallisCycle vallis;

  static const _title = 'Orb Vallis Cycle';

  @override
  Future<void> notify() async {
    final topic =
        vallis.isWarm ? NotificationKeys.warmKey : NotificationKeys.coldKey;

    final key = topic;
    final ids = cache.getAllIds(key);

    final notification = Notification()
      ..title = _title
      ..body = 'It is ${vallis.isWarm ? 'warm' : 'cold'} out on Orb Vallis';

    if (ids.contains(vallis.id) || recurringEventLimiter(vallis.activation)) {
      return;
    }

    await auth.send(topic, notification);
    cache.addId(key, ids..add(vallis.id));
  }
}
