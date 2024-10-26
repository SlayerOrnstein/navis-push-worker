import 'package:navis_push_worker/src/handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/messages/orbiter_news_message.dart';
import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

class OrbiterNewsHandler extends MessageHandler {
  OrbiterNewsHandler(this.orbiterNews);

  final List<News> orbiterNews;

  @override
  Future<void> notify(Send send, IdCache cache) async {
    for (final news in orbiterNews) {
      final date = await cache.get(news.id!);
      if (date != null) continue;

      final message = OrbiterNewsMessage(news);
      await send(message.topic, message.notification);

      await cache.set(
        key: news.id!,
        value: news.date,
        // News don't have expiry
        expiry: news.date.add(const Duration(days: 1000)),
      );
    }
  }
}
