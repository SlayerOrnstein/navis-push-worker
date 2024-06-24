import 'dart:async';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:navis_push_worker/handlers.dart';
import 'package:navis_push_worker/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

Future<void> main() async {
  const delay = Duration(minutes: 1);
  final logger = Logger();

  try {
    final client = WarframestatWebsocket.connect();
    final auth = await Auth.initialize();
    final cache = await MessageIdCache.init();

    logger.info('starting push notification worker');
    client
        .worldstateEvents()
        .distinct((p, n) => n.timestamp.difference(p.timestamp) < delay)
        .listen((w) => sendNotifications(w, auth, cache));

    // Timer.periodic(const Duration(seconds: 60), (_) async {
    //   final client = WorldstateClient();
    //   final state = await client.fetchWorldstate();

    //   await sendNotifications(state, auth, cache);
    // });
  } catch (e) {
    logger.err(e.toString());
    exit(1);
  }
}

Future<void> sendNotifications(
  Worldstate state,
  Auth auth,
  MessageIdCache cache,
) async {
  final handlers = <MessageHandler>[
    AlertHandler(state.alerts, auth, cache),
    BaroHandler(state.voidTraders, auth, cache),
    CetusHandler(state.cetusCycle, auth, cache),
    DarvoDealHandler(state.dailyDeals, auth, cache),
    DuviriHandler(state.duviriCycle, auth, cache),
    EarthHandler(state.earthCycle, auth, cache),
    CambionHandler(state.cambionCycle, auth, cache),
    Invasionhandler(state.invasions, auth, cache),
    OrbiterNewsHandler(state.news, auth, cache),
    SortieHandler(state.sortie, auth, cache),
    ArchonHandler(state.archonHunt, auth, cache),
    VallisHandler(state.vallisCycle, auth, cache),
    FissuresHandler(state.fissures, auth, cache),
  ];

  for (final handler in handlers) {
    await handler.notify();
  }
}
