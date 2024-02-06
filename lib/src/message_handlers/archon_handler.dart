import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/handlers.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/utils.dart';
import 'package:warframestat_client/warframestat_client.dart';

class ArchonHandler extends MessageHandler {
  ArchonHandler(this.archon);

  final Sortie archon;

  @override
  Future<void> notify() async {
    const topic = NotificationKeys.archonHunt;
    const title = 'Archon Hunt';

    final key = cacheKey(platform, topic);
    final ids = cache.getAllIds(key);

    if (ids.contains(archon.id)) return;

    final notification = Notification()
      ..title = title
      ..body = 'New Archon hunt target ${archon.boss}';

    await auth.send(topic, notification);
    cache.addId(key, ids..add(archon.id));
  }
}
