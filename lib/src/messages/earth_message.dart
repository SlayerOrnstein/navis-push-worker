import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:worldstate_models/worldstate_models.dart';

class EarthMessage extends MessageBase {
  EarthMessage(this.earth);

  final CetusCycle earth;

  @override
  String get body => 'It is now ${earth.state.name} on earth';

  @override
  String get topic => earth.isDay
      ? NotificationKeys.earthDayKey
      : NotificationKeys.earthNightKey;

  @override
  String get title => 'Earth Cycle';
}
