import 'dart:async';

import 'package:mason_logger/mason_logger.dart';
import 'package:navis_push_worker/handlers.dart';
import 'package:navis_push_worker/services.dart';
import 'package:warframestat_client/warframestat_client.dart';

Future<void> main() async {
  await registerServices();

  final logger = locator<Logger>()..info('Starting push_server');
  final client = WorldstateClient();

  try {
    logger.info('Listening to websocket');
    client.worldstateWebSocket().listen(sendNotifications);
    logger.info('Started push_server');
  } catch (e) {
    logger.err(e.toString());
  }
}

Future<void> sendNotifications(Worldstate state) async {
  final handlers = <MessageHandler>[
    AlertHandler(state.alerts),
    BaroHandler(state.voidTraders),
    CetusHandler(state.cetusCycle),
    DarvoDealHandler(state.dailyDeals),
    // DuviriHandler(state.duviriCycle),
    EarthHandler(state.earthCycle),
    CambionHandler(state.cambionCycle),
    Invasionhandler(state.invasions),
    OrbiterNewsHandler(state.news),
    SortieHandler(state.sortie),
    ArchonHandler(state.archonHunt),
    VallisHandler(state.vallisCycle),
    FissuresHandler(state.fissures),
  ];

  for (final handler in handlers) {
    await handler.notify();
  }
}
