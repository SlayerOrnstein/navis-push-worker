import 'dart:async';
import 'dart:io';

import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:logger/logger.dart';
import 'package:navis_push_worker/navis_push_worker.dart';
import 'package:shorebird_redis_client/shorebird_redis_client.dart';

Future<void> main() async {
  final logger = Logger(filter: ProductionFilter(), level: Level.error);

  final projectId = Platform.environment['FIREBASE_PROJECT'];
  if (projectId == null) throw Exception('FIREBASE_PROJECT not provided');

  final redisUrl = Platform.environment['REDIS_URL'];
  if (redisUrl == null) throw Exception('Missing REDIS_URL');

  try {
    final uri = Uri.parse(redisUrl);
    final redis = RedisClient(
      logger: RedisCustomLogger(logger),
      socket: RedisSocketOptions(host: uri.host, port: uri.port),
    );

    await redis.connect();
    await redis.auth(password: uri.userInfo.replaceAll(':', ''));

    final adminApp = FirebaseAdminApp.initializeApp(
      projectId,
      getServiceAccount(),
    );

    final messenger = FirebaseMessenger(admin: adminApp, logger: logger);
    final cache = RedisIdCache(redis);

    logger.i('starting push notification worker');
    PushNotifier(auth: messenger, cache: cache, logger: logger)
      ..addHandler((state) => AlertHandler(state.events, state.alerts))
      ..addHandler((state) => BaroHandler(state.voidTraders))
      ..addHandler((state) => CetusHandler(state.cetusCycle))
      ..addHandler((state) => DarvoDealHandler(state.dailyDeals))
      ..addHandler((state) => DuviriHandler(state.duviriCycle))
      ..addHandler((state) => CambionHandler(state.cambionCycle))
      ..addHandler((state) => Invasionhandler(state.invasions))
      ..addHandler((state) => OrbiterNewsHandler(state.news))
      ..addHandler((state) => SortieHandler(state.sortie))
      ..addHandler((state) => ArchonHandler(state.archonHunt))
      ..addHandler((state) => VallisHandler(state.vallisCycle))
      ..addHandler((state) => FissuresHandler(state.fissures));
  } on Exception catch (e) {
    logger.e(e.toString());
    exit(1);
  }
}
