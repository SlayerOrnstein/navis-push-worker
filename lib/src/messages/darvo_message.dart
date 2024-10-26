import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:warframestat_client/warframestat_client.dart';

class DarvoMessage extends MessageBase {
  DarvoMessage(this.deal);

  final DailyDeal deal;

  @override
  String get body {
    return '${deal.item} is on sale for ${deal.discount}% off '
        "or ${deal.salePrice}p if you don't want to do the math";
  }

  @override
  String get topic => NotificationKeys.darvoKey;

  @override
  String get title => 'Darvo Deal';
}
