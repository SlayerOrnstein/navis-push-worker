// I want the abstract class in this case

import 'dart:async';

import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';

abstract class MessageHandler {
  FutureOr<void> notify(Send send, IdCache cache);
}
