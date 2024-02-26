import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:warframestat_client/warframestat_client.dart';

class SentientOutpostHandler extends MessageHandler {
  SentientOutpostHandler(this.outpost, super.auth, super.cache);

  final SentientOutpost outpost;

  @override
  Future<void> notify() async {
    // final key = cacheKey(platform, 'sentient_outpost');
    // final ids = await redis.getAllIds(key);

    final isOverlimit = recurringEventLimiter(outpost.activation!);

    if (!isOverlimit && outpost.active) {
      final notification = Notification()
        ..title = 'Sentient Outpost'
        ..body = 'Sentient outpost located in ${outpost.mission?.node}';

      await auth.send('sentient_outpost', notification);
      // await redis.addId(key, id);
    }
  }
}
