import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:warframestat_client/warframestat_client.dart';

class VallisMessage extends MessageBase {
  VallisMessage(this.vallis);

  final VallisCycle vallis;

  @override
  String get body => 'It is ${vallis.state.name} out on Orb Vallis';

  @override
  String get title => 'Orb Vallis Cycle';

  @override
  String get topic =>
      vallis.isWarm ? NotificationKeys.warmKey : NotificationKeys.coldKey;
}
