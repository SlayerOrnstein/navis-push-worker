import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:warframestat_client/warframestat_client.dart';

class BaroMessage extends MessageBase {
  BaroMessage(this.trader);

  final Trader trader;

  @override
  String get body => '${trader.character} has arrived on ${trader.location}';

  @override
  String get topic => NotificationKeys.baroKey;

  @override
  String get title => trader.character;
}
