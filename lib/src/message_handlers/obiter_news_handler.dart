import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:navis_push_worker/src/utils.dart';
import 'package:warframestat_client/warframestat_client.dart';

class OrbiterNewsHandler extends MessageHandler {
  OrbiterNewsHandler(this.orbiterNews);

  final List<News> orbiterNews;

  static const _primeAccess = 'Warframe Prime access';
  static const _update = 'Warframe Update';
  static const _stream = 'Warframe Stream';

  @override
  Future<void> notify() async {
    final key = cacheKey(platform, 'orbiter_news');
    final ids = cache.getAllIds(key);

    for (final news in orbiterNews) {
      if (ids.contains(news.id) ||
          recurringEventLimiter(news.date, limit: const Duration(hours: 1))) {
        continue;
      }

      if (news.primeAccess) {
        final notification = Notification()
          ..title = _primeAccess
          ..body = news.message;

        await auth.send(NotificationKeys.newsPrimeKey, notification);
      } else if (news.update) {
        final notification = Notification()
          ..title = _update
          ..body = news.message;

        await auth.send(NotificationKeys.newsUpdateKey, notification);
      } else if (news.stream) {
        final notification = Notification()
          ..title = _stream
          ..body = news.message;

        await auth.send(NotificationKeys.newsStreamKey, notification);
      }

      cache.addId(key, ids..add(news.id!));
    }
  }
}
