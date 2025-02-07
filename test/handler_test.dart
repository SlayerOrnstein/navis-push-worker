import 'dart:async';

import 'package:dart_firebase_admin/messaging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:navis_push_worker/navis_push_worker.dart';
import 'package:test/test.dart';
import 'package:warframestat_client/warframestat_client.dart';

class MockIdCache extends Mock implements IdCache {
  final _cache = <String, String>{};

  @override
  FutureOr<String?> get(String key) {
    return _cache[key];
  }

  @override
  void set({required String key, required DateTime value, Duration? ttl}) {
    _cache[key] = value.toIso8601String();
  }
}

Future<void> main() async {
  final cache = MockIdCache();
  final client = WorldstateClient();
  final worldstate = await client.fetchWorldstate();

  final messages = <String, String>{};

  void send(String topic, Notification notification) {
    final message = messages[notification.title];
    expect(message, notification.body);
  }

  tearDown(messages.clear);

  test(
    'Test AlertHandler()',
    () async {
      for (final alert in worldstate.alerts) {
        final message = AlertMessage(alert);
        messages[message.title] = message.body;
      }

      await AlertHandler(worldstate.alerts).notify(send, cache);
    },
    skip: worldstate.alerts.isEmpty,
  );

  test('Test ArchonHandler()', () async {
    final message = ArchonMessage(worldstate.archonHunt);
    messages[message.title] = message.body;

    await ArchonHandler(worldstate.archonHunt).notify(send, cache);
  });

  test(
    'Test BaroHandler()',
    () async {
      for (final trader in worldstate.voidTraders) {
        final message = BaroMessage(trader);
        messages[message.title] = message.body;
      }

      await BaroHandler(worldstate.voidTraders).notify(send, cache);
    },
    skip: worldstate.voidTraders.isEmpty,
  );

  test('Test CambionHandler()', () async {
    final message = CambionMessage(worldstate.cambionCycle);
    messages[message.title] = message.body;

    await CambionHandler(worldstate.cambionCycle).notify(send, cache);
  });

  test('Test CetusHandler()', () async {
    final message = CetusMessage(worldstate.cetusCycle);
    messages[message.title] = message.body;

    await ArchonHandler(worldstate.archonHunt).notify(send, cache);
  });

  test(
    'Test DarvoHandler()',
    () async {
      for (final deal in worldstate.dailyDeals) {
        final message = DarvoMessage(deal);
        messages[message.title] = message.body;
      }

      await BaroHandler(worldstate.voidTraders).notify(send, cache);
    },
    skip: worldstate.dailyDeals.isEmpty,
  );

  test('Test DuviriHandler()', () async {
    final message = DuviriMessage(worldstate.duviriCycle);
    messages[message.title] = message.body;

    await DuviriHandler(worldstate.duviriCycle).notify(send, cache);
  });

  test('Test EarthHandler()', () async {
    final message = EarthMessage(worldstate.earthCycle);
    messages[message.title] = message.body;

    await EarthHandler(worldstate.earthCycle).notify(send, cache);
  });

  test(
    'Test FissureHandler()',
    () async {
      final dups = <Fissure>[];
      for (final fissure in worldstate.fissures) {
        final message = FissureMessage(fissure);
        // Fissures can have the same title so use remove the instances
        if (messages.containsKey(message.title)) {
          dups.add(fissure);
          continue;
        }

        messages[message.title] = message.body;
      }

      void send(String topic, Notification notification) {
        final message = messages[notification.title];
        expect(message, notification.body);
      }

      await FissuresHandler(worldstate.fissures..removeWhere(dups.contains))
          .notify(send, cache);
    },
    skip: worldstate.fissures.isEmpty,
  );

  test(
    'Test InvasionHandler()',
    () async {
      for (final invasion in worldstate.invasions) {
        final message = InvasionMessage(invasion);
        messages[message.body] = message.title;
      }

      await Invasionhandler(worldstate.invasions).notify(send, cache);
    },
    skip: true,
  );

  test(
    'Test OrbiterNewsHandler()',
    () async {
      for (final news in worldstate.news) {
        final message = OrbiterNewsMessage(news);
        messages[message.body] = message.title;
      }

      // News can have the same title so use the body as the key instead
      void send(String topic, Notification notification) {
        final message = messages[notification.body];
        expect(message, notification.title);
      }

      await OrbiterNewsHandler(worldstate.news).notify(send, cache);
    },
    skip: worldstate.news.isEmpty,
  );

  test(
    'Test SentientOutpostHandler()',
    () async {
      final message = SentientMessage(worldstate.sentientOutposts!);
      messages[message.title] = message.body;

      await SentientOutpostHandler(worldstate.sentientOutposts!)
          .notify(send, cache);
    },
    skip: worldstate.sentientOutposts == null,
  );

  test('Test SortieHandler()', () async {
    final message = SortieMessage(worldstate.sortie);
    messages[message.title] = message.body;

    await SortieHandler(worldstate.sortie).notify(send, cache);
  });

  test('Test VallisHandler()', () async {
    final message = VallisMessage(worldstate.vallisCycle);
    messages[message.title] = message.body;

    await VallisHandler(worldstate.vallisCycle).notify(send, cache);
  });
}
