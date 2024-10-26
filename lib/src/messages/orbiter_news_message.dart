import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:warframestat_client/warframestat_client.dart';

class OrbiterNewsMessage extends MessageBase {
  OrbiterNewsMessage(this.news);

  final News news;

  @override
  String get body => news.message;

  @override
  String get topic {
    if (news.primeAccess) return NotificationKeys.newsUpdateKey;
    if (news.stream) return NotificationKeys.newsStreamKey;

    return NotificationKeys.newsPrimeKey;
  }

  @override
  String get title {
    if (news.primeAccess) return 'Warframe Update';
    if (news.stream) return 'Warframe Stream';

    return 'Warframe Prime access';
  }
}
