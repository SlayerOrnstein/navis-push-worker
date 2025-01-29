import 'dart:async';

import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/src/handlers/handlers.dart';
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

typedef Send = FutureOr<void> Function(String topic, Notification notification);

typedef Notifier = Future<void> Function(Send send, RedisIdCache cache);

typedef BuildHandler = MessageHandler Function(Worldstate state);

class PushNotifier {
  PushNotifier({
    required WarframestatWebsocket websocket,
    required FirebaseMessenger auth,
    required IdCache cache,
  })  : _auth = auth,
        _cache = cache {
    const delay = Duration(seconds: 60);

    websocket
        .worldstate()
        .distinct((p, n) => n.timestamp.difference(p.timestamp) < delay)
        .listen(_startDispatch);
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
}
