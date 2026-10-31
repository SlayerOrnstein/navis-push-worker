import 'dart:async';
import 'dart:convert';

import 'package:firebase_admin_sdk/messaging.dart';
import 'package:http/http.dart' as http;
import 'package:navis_push_worker/src/services/services.dart';
import 'package:warframe_worldstate_data/warframe_worldstate_data.dart';

typedef _ArbitrationSchedule = ({DateTime activation, String key});

Future<void> setupArbitrationTimers(FirebaseMessenger messenger, RedisIdCache cache) async {
  var arbitrations = await cache.get('arby');
  if (arbitrations == null) {
    final res = await http.get(Uri.parse('https://browse.wf/arbys.txt'));
    await cache.store('arby', res.body);
    arbitrations = res.body;
  }

  final timestamp = DateTime.timestamp();
  for (final arbitration in _parseArbitrations(arbitrations)) {
    final timeUntil = arbitration.activation.difference(timestamp);
    if (timeUntil < Duration.zero) continue;

    Timer(timeUntil, () async {
      final node = solNodes().fetchNode(arbitration.key);
      await messenger.send(
        'arbitrations',
        Notification(title: 'Arbitration', body: '${node.name} | ${node.type} | ${node.enemy}'),
      );
    });
  }
}

Iterable<_ArbitrationSchedule> _parseArbitrations(String csv) sync* {
  final timestamp = DateTime.timestamp();
  final lines = const LineSplitter().convert(csv);

  for (final line in lines) {
    final [seconds, key] = line.split(',');
    final activation = DateTime.fromMillisecondsSinceEpoch(int.parse(seconds) * 1000);

    if (timestamp.isAfter(activation)) continue;

    yield (activation: activation, key: key);
  }
}
