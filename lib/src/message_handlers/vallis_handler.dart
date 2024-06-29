import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:warframestat_client/warframestat_client.dart';

class VallisHandler extends MessageHandler {
  VallisHandler(this.vallis, super.auth, super.cache);

  final VallisCycle vallis;

  @override
  Future<void> notify() async {
    final topic =
        vallis.isWarm ? NotificationKeys.warmKey : NotificationKeys.coldKey;

    final ids = cache.getAllIds(topic);

    if (ids.contains(vallis.id)) return;
    cache.addId(topic, ids..add(vallis.id));

    final notification = Notification(
      title: 'Orb Vallis Cycle',
      body: 'It is ${vallis.isWarm ? 'warm' : 'cold'} out on Orb Vallis',
    );

    await auth.send(topic, notification);
  }
}
