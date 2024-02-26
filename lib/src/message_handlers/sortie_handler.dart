import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:warframestat_client/warframestat_client.dart';

class SortieHandler extends MessageHandler {
  SortieHandler(this.sortie, super.auth, super.cache);

  final Sortie sortie;

  static const _title = 'Sorties';
  static const _body = 'New sortie available';

  @override
  Future<void> notify() async {
    const key = NotificationKeys.sortiesKey;
    final ids = cache.getAllIds(key);

    final notification = Notification()
      ..title = _title
      ..body = _body;

    if (ids.contains(sortie.id) || recurringEventLimiter(sortie.activation)) {
      return;
    }

    await auth.send(NotificationKeys.sortiesKey, notification);
    cache.addId(key, ids..add(sortie.id));
  }
}
