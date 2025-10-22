import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:worldstate_models/worldstate_models.dart';

class ArchonMessage extends MessageBase {
  ArchonMessage(this.archon);

  final Sortie archon;

  @override
  String get body => 'New target ${archon.boss}';

  @override
  String get topic => NotificationKeys.archonHunt;

  @override
  String get title => 'Archon Hunt';
}
