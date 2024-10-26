import 'dart:async';

import 'package:shorebird_redis_client/shorebird_redis_client.dart';

abstract class IdCache {
  FutureOr<String?> get(String key);

  FutureOr<void> set({
    required String key,
    required DateTime value,
    required DateTime expiry,
  });
}

class RedisIdCache implements IdCache {
  RedisIdCache(RedisClient client) : _client = client;

  final RedisClient _client;

  @override
  Future<String?> get(String key) => _client.get(key: key);

  @override
  Future<void> set({
    required String key,
    required DateTime value,
    required DateTime expiry,
  }) async {
    await _client.set(
      key: key,
      value: value.toIso8601String(),
      ttl: DateTime.timestamp().difference(expiry).abs(),
    );
  }
}
