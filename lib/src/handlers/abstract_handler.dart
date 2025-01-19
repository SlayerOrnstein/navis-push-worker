// I want the abstract class in this case
// ignore_for_file: one_member_abstracts

import 'dart:async';

import 'package:navis_push_worker/src/push_notifier.dart';
import 'package:navis_push_worker/src/services/services.dart';

abstract class MessageHandler {
  FutureOr<void> notify(Send send, IdCache cache);
}
