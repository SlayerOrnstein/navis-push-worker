import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:warframestat_client/warframestat_client.dart';

class SortieHandler extends MessageHandler {
  SortieHandler(this.sortie, super.auth, super.cache);

  final Sortie sortie;

  @override
  Future<void> notify() async {
    const key = NotificationKeys.sortiesKey;
    final ids = cache.getAllIds(key);

    if (ids.contains(sortie.id)) return;
    cache.addId(key, ids..add(sortie.id));

    final notification = Notification(
      title: 'Sorties',
      body: 'New sortie available',
    );

    await auth.send(NotificationKeys.sortiesKey, notification);
  }
}
