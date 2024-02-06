import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:navis_push_worker/src/utils.dart';
import 'package:time/time.dart';
import 'package:warframestat_client/warframestat_client.dart';

class SortieHandler extends MessageHandler {
  SortieHandler(this.sortie);

  final Sortie sortie;

  static const _title = 'Sorties';
  static const _body = 'New sortie available';

  @override
  Future<void> notify() async {
    final key = cacheKey(platform, NotificationKeys.sortiesKey);
    final ids = cache.getAllIds(key);

    final notification = Notification()
      ..title = _title
      ..body = _body;

    final isPassLimit =
        recurringEventLimiter(sortie.activation, limit: 1.minutes);

    if (ids.contains(sortie.id) || isPassLimit) {
      return;
    }

    await auth.send(NotificationKeys.sortiesKey, notification);
    cache.addId(key, ids..add(sortie.id));
  }
}
