import 'package:intl/intl.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:warframestat_client/warframestat_client.dart';

class CambionMessage extends MessageBase {
  CambionMessage(this.cambion);

  final CambionCycle cambion;

  @override
  String get body {
    final worm = toBeginningOfSentenceCase(cambion.state.name);

    return '$worm looks over Cambion Drift with malicious intent';
  }

  @override
  String get topic => cambion.state == CambionState.fass
      ? NotificationKeys.fassKey
      : NotificationKeys.vomeKey;

  @override
  String get title => 'Cambion Cycle';
}
