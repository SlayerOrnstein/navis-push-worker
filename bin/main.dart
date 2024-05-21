import 'dart:async';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:navis_push_worker/handlers.dart';
import 'package:navis_push_worker/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

const delay = Duration(seconds: 60);

Future<void> main() async {
  final logger = Logger()..info('Starting push_server');

  try {
    final client = WarframestatWebsocket.connect();
    final auth = await Auth.initialize();
    final cache = await MessageIdCache.init();

    logger.info('Listening to websocket');

    client
        .worldstateEvents()
        .distinct((p, n) => p.timestamp.difference(n.timestamp).abs() >= delay)
        .listen((w) => sendNotifications(w, auth, cache));

    logger.info('Started push_server');
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
    // DuviriHandler(state.duviriCycle, auth, cache),
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
