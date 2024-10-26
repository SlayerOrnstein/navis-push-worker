import 'package:navis_push_worker/src/messages/message_base.dart';
import 'package:warframestat_client/warframestat_client.dart';

class DuviriMessage extends MessageBase {
  DuviriMessage(this.duviri);

  final DuviriCycle duviri;

  @override
  String get body => 'The current state of Duviri is ${duviri.state.name}';

  @override
  String get topic => 'duviri_${duviri.state.name}';

  @override
  String get title => 'Duviri Cycle';
}
