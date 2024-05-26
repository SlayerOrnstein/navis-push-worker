import 'package:googleapis/fcm/v1.dart';
import 'package:mocktail/mocktail.dart';
import 'package:navis_push_worker/handlers.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';
import 'package:warframestat_client/warframestat_client.dart';

import '../mocks.dart';

void main() {
  final now = DateTime.timestamp();
  late MockAuth mockAuth;
  late MockMessageCache mockCache;

  setUp(() {
    registerFallbackValue(Notification());

    mockAuth = MockAuth();
    mockCache = MockMessageCache();
  });

  group('[BaroHandler] arrivial', () {
    final mock = {
      'id': '',
      'activation': now.toIso8601String(),
      'expiry': now.add(50.minutes).toIso8601String(),
      'active': true,
      'character': 'Baro',
      'location': 'Mars',
      'inventory': <Map<String, dynamic>>[],
      'initialStart': now.toIso8601String(),
      'schedule': <Map<String, dynamic>>[],
    };

    test('notifies for arrivial', () async {
      when(() => mockAuth.send(NotificationKeys.baroKey, any()))
          .thenDoNothing();

      final notification = Notification()
        ..title = "Baro Ki'Teer"
        ..body = "Baro Ki'Teer has arrived";

      final handler = BaroHandler([Trader.fromJson(mock)], mockAuth, mockCache);
      final matcher = isA<Notification>().having(
        (n) => n.body,
        'Notification body',
        contains(notification.body),
      );

      await handler.notify();
      verify(() => mockAuth.send(NotificationKeys.baroKey, any(that: matcher)))
          .called(1);
    });

    test("doesn't repeat after notiication window", () async {
      when(() => mockAuth.send(NotificationKeys.baroKey, any()))
          .thenDoNothing();

      mock['activation'] = now.subtract(2.minutes).toIso8601String();

      final handler = BaroHandler([Trader.fromJson(mock)], mockAuth, mockCache);

      await handler.notify();
      verifyNever(() => mockAuth.send(NotificationKeys.baroKey, any()));
    });
  });

  group('[BaroHandler] departure', () {
    final mock = {
      'id': '',
      'activation': now.subtract(59.minutes).toIso8601String(),
      'expiry': now.add(59.minutes).toIso8601String(),
      'active': true,
      'character': 'Baro',
      'location': 'Mars',
      'inventory': <Map<String, dynamic>>[],
      'initialStart': now.toIso8601String(),
      'schedule': <Map<String, dynamic>>[],
    };

    test('notifies an hour before', () async {
      when(() => mockAuth.send(NotificationKeys.baroKey, any()))
          .thenDoNothing();

      final notification = Notification()
        ..title = "Baro Ki'Teer"
        ..body = "Baro Ki'Teer is leaving soon";

      final handler = BaroHandler([Trader.fromJson(mock)], mockAuth, mockCache);
      final matcher = isA<Notification>().having(
        (n) => n.body,
        'Notification body',
        contains(notification.body),
      );

      await handler.notify();
      verify(() => mockAuth.send(NotificationKeys.baroKey, any(that: matcher)))
          .called(1);
    });

    test("doesn't repeat after notiication window", () async {
      when(() => mockAuth.send(NotificationKeys.baroKey, any()))
          .thenDoNothing();

      final expiry = DateTime.parse(mock['expiry']! as String);
      mock['expiry'] = expiry.subtract(1.minutes).toIso8601String();

      final handler = BaroHandler([Trader.fromJson(mock)], mockAuth, mockCache);

      await handler.notify();
      verifyNever(() => mockAuth.send(NotificationKeys.baroKey, any()));
    });
  });
}
