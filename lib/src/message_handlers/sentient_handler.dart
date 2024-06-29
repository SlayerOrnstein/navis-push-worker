import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:warframestat_client/warframestat_client.dart';

class SentientOutpostHandler extends MessageHandler {
  SentientOutpostHandler(this.outpost, super.auth, super.cache);

  final SentientOutpost outpost;

  @override
  Future<void> notify() async {
    final ids = cache.getAllIds(NotificationKeys.sentientOutpost);
    cache.addId(NotificationKeys.sentientOutpost, ids..add(outpost.id));

    if (outpost.active) {
      final notification = Notification(
        title: 'Sentient Outpost',
        body: 'Sentient outpost located in ${outpost.mission?.node}',
      );

      await auth.send(NotificationKeys.sentientOutpost, notification);
    }
  }
}
