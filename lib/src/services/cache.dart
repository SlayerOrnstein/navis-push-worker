import 'dart:io';

import 'package:hive/hive.dart';

class MessageIdCache {
  static Box<List<String>>? _box;
  static MessageIdCache? _instance;

  static Future<MessageIdCache> init() async {
    final temp = Directory.systemTemp;

    Hive.init(temp.path);
    _box ??= await Hive.openBox<List<String>>('id_cache');

    return _instance ??= MessageIdCache();
  }

  List<String> getAllIds(String key) {
    return _box?.get(key) ?? <String>[];
  }

  void addId(String topic, List<String> ids) {
    _box?.put(topic, ids);
  }
}
