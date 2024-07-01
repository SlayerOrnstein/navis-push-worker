import 'package:mocktail/mocktail.dart';
import 'package:navis_push_worker/services.dart';

class MockAuth extends Mock implements FirebaseMessenger {}

class MockMessageCache extends Mock implements MessageIdCache {
  final _temp = <String, List<String>>{};

  @override
  List<String> getAllIds(String key) {
    return _temp[key] ?? <String>[];
  }

  @override
  void addId(String key, List<String> ids) {
    _temp[key] = ids;
  }
}

extension MockAsync on When<Future<void>> {
  void thenDoNothing() => thenAnswer((_) async {});
}
