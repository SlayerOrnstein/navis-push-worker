import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/handlers.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:warframestat_client/warframestat_client.dart';

class DuviriHandler extends MessageHandler {
  DuviriHandler(this.duviriCycle, super.auth, super.cache);

  final DuviriCycle duviriCycle;

  @override
  Future<void> notify() async {
    final topic = 'duviri_${duviriCycle.state}';
    final key = topic;
    final ids = cache.getAllIds(key);

    if (ids.contains(duviriCycle.id) ||
        recurringEventLimiter(duviriCycle.activation)) return;

    final notification = Notification()
      ..title = 'Duviri Cycle'
      ..body = 'The current mood in Duviri is ${duviriCycle.state}';

    await auth.send(topic, notification);
    cache.addId(key, ids..add(duviriCycle.id));
  }
}
