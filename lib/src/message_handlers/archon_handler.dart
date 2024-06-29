import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/handlers.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:warframestat_client/warframestat_client.dart';

class ArchonHandler extends MessageHandler {
  ArchonHandler(this.archon, super.auth, super.cache);

  final Sortie archon;

  @override
  Future<void> notify() async {
    const key = NotificationKeys.archonHunt;
    const title = 'Archon Hunt';

    final ids = cache.getAllIds(key);

    if (ids.contains(archon.id)) return;

    final notification = Notification(
      title: title,
      body: 'New Archon hunt target ${archon.boss}',
    );

    if (recurringEventLimiter(archon.activation)) return;

    await auth.send(key, notification);
    cache.addId(key, ids..add(archon.id));
  }
}
