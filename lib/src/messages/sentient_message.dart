import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:worldstate_models/worldstate_models.dart';

class SentientMessage extends MessageBase {
  SentientMessage(this.outpost);

  final SentientOutpost outpost;

  @override
  String get body => 'Sentient outpost located in ${outpost.node.name}';

  @override
  String get title => 'Sentient Outpost';

  @override
  String get topic => NotificationKeys.sentientOutpost;
}
