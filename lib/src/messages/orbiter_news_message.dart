import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:worldstate_models/worldstate_models.dart';

class OrbiterNewsMessage extends MessageBase {
  OrbiterNewsMessage(this.news);

  final News news;

  @override
  String get body => news.message;

  @override
  String get topic {
    if (news.isPrimeAccess) return NotificationKeys.newsUpdateKey;
    if (news.isStream) return NotificationKeys.newsStreamKey;

    return NotificationKeys.newsPrimeKey;
  }

  @override
  String get title {
    if (news.isPrimeAccess) return 'Warframe Update';
    if (news.isStream) return 'Warframe Stream';

    return 'Warframe Prime access';
  }
}
