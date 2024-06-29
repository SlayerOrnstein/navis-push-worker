import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:warframestat_client/warframestat_client.dart';

class FissuresHandler extends MessageHandler {
  FissuresHandler(this.fissures, super.auth, super.cache);

  final List<Fissure> fissures;

  @override
  Future<void> notify() async {
    final ids = cache.getAllIds('fissures');

    for (final fissure in fissures) {
      if (fissure.expired) continue;
      if (ids.contains(fissure.id)) continue;

      var title = '${fissure.tier} Fissure';
      if (fissure.isHard) title = '${fissure.tier} - Steel Path';
      if (fissure.isStorm) title = '${fissure.tier} - Void Storm';

      final notification = Notification(
        title: title,
        body: '${fissure.node} - ${fissure.missionType} - ${fissure.enemy}',
      );

      cache.addId('fissures', ids..add(fissure.id));

      final missionType = fissure.missionType;
      await auth.send(
        '${fissure.tier}.${missionType.replaceAll(' ', '_').toLowerCase()}',
        notification,
      );
    }
  }
}
