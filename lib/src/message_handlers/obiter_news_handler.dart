import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:warframestat_client/warframestat_client.dart';

class OrbiterNewsHandler extends MessageHandler {
  OrbiterNewsHandler(this.orbiterNews, super.auth, super.cache);

  final List<News> orbiterNews;

  @override
  Future<void> notify() async {
    const key = 'orbiter_news';
    final ids = cache.getAllIds(key);

    for (final news in orbiterNews) {
      if (ids.contains(news.id)) continue;
      cache.addId(key, ids..add(news.id!));

      var topic = NotificationKeys.newsPrimeKey;
      if (news.primeAccess) topic = NotificationKeys.newsUpdateKey;
      if (news.stream) topic = NotificationKeys.newsStreamKey;

      var title = 'Warframe Prime access';
      if (news.primeAccess) title = 'Warframe Update';
      if (news.stream) title = 'Warframe Stream';

      await auth.send(topic, Notification(title: title, body: news.message));
    }
  }
}
