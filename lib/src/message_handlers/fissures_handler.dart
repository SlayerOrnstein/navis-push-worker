import 'package:googleapis/fcm/v1.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:warframestat_client/warframestat_client.dart';

class FissuresHandler extends MessageHandler {
  FissuresHandler(this.fissures);

  final List<Fissure> fissures;

  @override
  Future<void> notify() async {
    final ids = cache.getAllIds('fissures');

    for (final fissure in fissures) {
      if (fissure.expired) continue;
      if (ids.contains(fissure.id)) continue;

      final notification = Notification()
        ..title = '${fissure.tier} Fissure'
        ..body = '${fissure.node} - ${fissure.missionType} - ${fissure.enemy}';

      if (fissure.isHard) notification.title = 'Arbitration - ${fissure.tier}';
      if (fissure.isStorm) notification.title = 'Void Storm - ${fissure.tier}';

      cache.addId('fissures', ids..add(fissure.id));

      final missionType = fissure.missionType;
      await auth.send(
        '${fissure.tier}.${missionType.replaceAll(' ', '_').toLowerCase()}',
        notification,
      );
    }
  }
}
