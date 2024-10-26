import 'dart:async';
import 'dart:io';

import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:navis_push_worker/navis_push_worker.dart';
import 'package:shorebird_redis_client/shorebird_redis_client.dart';
import 'package:warframestat_client/warframestat_client.dart';

Future<void> main() async {
  final logger = Logger();

  final projectId = Platform.environment['FIREBASE_PROJECT'];
  if (projectId == null) throw Exception('FIREBASE_PROJECT not provided');

  try {
    final redis = RedisClient(logger: RedisMasonLogger());
    await redis.connect();

    final client = WarframestatWebsocket.connect();
    final adminApp = FirebaseAdminApp.initializeApp(
      projectId,
      getServiceAccount(),
    );

    final messenger = FirebaseMessenger(admin: adminApp, projectId: projectId);
    final cache = RedisIdCache(redis);

    logger.info('starting push notification worker');
    PushNotifier(websocket: client, auth: messenger, cache: cache)
      ..addHandler((state) => AlertHandler(state.alerts))
      ..addHandler((state) => BaroHandler(state.voidTraders))
      ..addHandler((state) => CetusHandler(state.cetusCycle))
      ..addHandler((state) => DarvoDealHandler(state.dailyDeals))
      ..addHandler((state) => DuviriHandler(state.duviriCycle))
      ..addHandler((state) => EarthHandler(state.earthCycle))
      ..addHandler((state) => CambionHandler(state.cambionCycle))
      ..addHandler((state) => Invasionhandler(state.invasions))
      ..addHandler((state) => OrbiterNewsHandler(state.news))
      ..addHandler((state) => SortieHandler(state.sortie))
      ..addHandler((state) => ArchonHandler(state.archonHunt))
      ..addHandler((state) => VallisHandler(state.vallisCycle))
      ..addHandler((state) => FissuresHandler(state.fissures));
  } catch (e) {
    logger.err(e.toString());
    exit(1);
  }
}
