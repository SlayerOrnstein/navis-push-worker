import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/handlers.dart';
import 'package:navis_push_worker/src/utils.dart';
import 'package:warframestat_client/warframestat_client.dart';

class DuviriHandler extends MessageHandler {
  DuviriHandler(this.duviriCycle);

  final DuviriCycle duviriCycle;

  @override
  Future<void> notify() async {
    final topic = 'duviri_${duviriCycle.state}';
    final key = cacheKey(platform, topic);
    final ids = cache.getAllIds(key);

    if (ids.contains(duviriCycle.id)) return;

    final notification = Notification()
      ..title = 'Duviri Cycle'
      ..body = 'The current mood in Duviri is ${duviriCycle.state}';

    await auth.send(topic, notification);
    cache.addId(key, ids..add(duviriCycle.id));
  }
}
