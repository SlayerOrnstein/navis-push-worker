import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:worldstate_models/worldstate_models.dart';

class CetusMessage extends MessageBase {
  CetusMessage(this.cetus);

  final CetusCycle cetus;

  @override
  String get body => 'It is now ${cetus.state.name} on Cetus';

  @override
  String get topic =>
      cetus.isDay ? NotificationKeys.dayKey : NotificationKeys.nightKey;

  @override
  String get title => 'Cetus Cycle';
}
