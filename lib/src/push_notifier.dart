import 'dart:async';
import 'dart:convert';

import 'package:dart_firebase_admin/messaging.dart';
import 'package:http/http.dart' as http;
import 'package:navis_push_worker/src/handlers/handlers.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframe_drop_data/warframe_drop_data.dart';
import 'package:worldstate_models/worldstate_models.dart';

typedef Send = FutureOr<void> Function(String topic, Notification notification);

typedef Notifier = Future<void> Function(Send send, RedisIdCache cache);

typedef BuildHandler = MessageHandler Function(Worldstate state);

class PushNotifier {
  PushNotifier({
    required FirebaseMessenger auth,
    required IdCache cache,
  }) : _auth = auth,
       _cache = cache {
    const delay = Duration(seconds: 60);

    Stream<Future<Worldstate>>.periodic(
      delay,
      (_) => _fetchWorldstate(),
    ).asyncMap((fw) async => fw).listen(_startDispatch);
  }

  final FirebaseMessenger _auth;
  final IdCache _cache;

  final _handlers = <BuildHandler>[];
  void addHandler(BuildHandler handler) => _handlers.add(handler);

  Future<void> _startDispatch(Worldstate worldstate) async {
    for (final handler in _handlers) {
      await handler(worldstate).notify(_auth.send, _cache);
    }
  }

  Future<Worldstate> _fetchWorldstate() async {
    final response = await http.get(
      Uri.parse('https://api.warframe.com/cdn/worldState.php'),
    );

    // Drop data isn't needed for now so it's alright to just leave it empty
    final deps = Dependency(
      DropData(blueprintDrops: [], bountyRewardTables: []),
    );

    return RawWorldstate.fromMap(
      jsonDecode(response.body) as Map<String, dynamic>,
    ).toWorldstate(deps);
  }
}
