import 'dart:async';
import 'dart:convert';

import 'package:dart_firebase_admin/messaging.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:navis_push_worker/navis_push_worker.dart';
import 'package:test/test.dart';
import 'package:worldstate_models/worldstate_models.dart';

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

Future<Worldstate> fetchWorldstate() async {
  final response = await http.get(
    Uri.parse('https://api.warframe.com/cdn/worldState.php'),
  );

  // Drop data isn't needed for now so it's alright to just leave it empty
  final deps = Dependency([]);

  return RawWorldstate.fromMap(
    jsonDecode(response.body) as Map<String, dynamic>,
  ).toWorldstate(deps);
}

Future<void> main() async {
  final cache = MockIdCache();
  final worldstate = await fetchWorldstate();

  final messages = <String, String>{};

  void send(String topic, Notification notification) {
    final message = messages[notification.title];
    expect(message, notification.body);
  }

  tearDown(messages.clear);

  test(
    'Test AlertHandler()',
    () async {
      final handler = AlertHandler(worldstate.events, worldstate.alerts);

      final dups = <Alert>[];
      for (final alert in worldstate.alerts) {
        final operation = handler.operation(alert.tag);
        MessageBase message = AlertMessage(alert);
        if (AlertHandler.operationTags.contains(alert.tag) &&
            operation != null) {
          message = OperationAlertMessage(operation, alert);
        }

        if (messages.containsKey(message.title)) {
          dups.add(alert);
          continue;
        }

        messages[message.title] = message.body;
      }

      worldstate.alerts.removeWhere(dups.contains);
      await AlertHandler(
        worldstate.events,
        worldstate.alerts,
      ).notify(send, cache);
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

  test(
    'Test FissureHandler()',
    () async {
      final dups = <VoidFissure>[];
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

      await FissuresHandler(
        worldstate.fissures..removeWhere(dups.contains),
      ).notify(send, cache);
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

  test('Test SentientOutpostHandler()', () async {
    final message = SentientMessage(worldstate.sentientOutpost);
    messages[message.title] = message.body;

    await SentientOutpostHandler(
      worldstate.sentientOutpost,
    ).notify(send, cache);
  });

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
