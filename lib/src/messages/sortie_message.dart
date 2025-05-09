import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:warframestat_client/warframestat_client.dart';

class SortieMessage extends MessageBase {
  SortieMessage(this.sortie);

  final Sortie sortie;

  @override
  String get body => 'New target ${sortie.boss}';

  @override
  String get title => 'Sorties';

  @override
  String get topic => NotificationKeys.sortiesKey;
}
