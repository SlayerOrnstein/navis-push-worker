import 'dart:async';

import 'package:mason_logger/mason_logger.dart';
import 'package:navis_push_worker/handlers.dart';
import 'package:navis_push_worker/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

Future<void> main() async {
  final logger = Logger()..info('Starting push_server');
  final client = WorldstateClient();
  final auth = await Auth.initialize();
  final cache = await MessageIdCache.init();

  try {
    logger.info('Listening to websocket');
    client
        .worldstateWebSocket()
        .listen((w) => sendNotifications(w, auth, cache));

    logger.info('Started push_server');
  } catch (e) {
    logger.err(e.toString());
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
    // DuviriHandler(state.duviriCycle),
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
