import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/handlers.dart';
import 'package:warframestat_client/warframestat_client.dart';

class DuviriHandler extends MessageHandler {
  DuviriHandler(this.duviriCycle, super.auth, super.cache);

  final DuviriCycle duviriCycle;

  @override
  Future<void> notify() async {
    final state = duviriCycle.state.name;
    final topic = 'duviri_$state';
    final ids = cache.getAllIds(topic);

    if (ids.contains(duviriCycle.id)) return;

    final notification = Notification(
      title: 'Duviri Cycle',
      body: 'The child king is feeling $state',
    );

    await auth.send(topic, notification);
    cache.addId(topic, ids..add(duviriCycle.id));
  }
}
