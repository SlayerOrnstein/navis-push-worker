import 'package:get_it/get_it.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:navis_push_worker/src/services/auth.dart';
import 'package:navis_push_worker/src/services/cache.dart';

final GetIt locator = GetIt.instance;

Future<void> registerServices() async {
  final logger = Logger(level: Level.verbose);

  locator
    ..registerSingleton(logger, signalsReady: true)
    ..isReadySync<Logger>()
    ..registerSingletonAsync<MessageIdCache>(MessageIdCache.init)
    ..registerSingletonAsync<Auth>(Auth.initialize);
}
