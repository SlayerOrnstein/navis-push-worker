import 'package:dart_firebase_admin/messaging.dart';
import 'package:navis_push_worker/src/constants/topic_keys.dart';
import 'package:navis_push_worker/src/message_handlers/abstract_handler.dart';
import 'package:navis_push_worker/src/time_limits.dart';
import 'package:time/time.dart';
import 'package:warframestat_client/warframestat_client.dart';

class BaroHandler extends MessageHandler {
  BaroHandler(this.traders, super.auth, super.cache);

  final List<Trader> traders;

  @override
  Future<void> notify() async {
    final trader = traders.first;

    final timeLeft = trader.expiry.difference(DateTime.timestamp());
    final isLeaving = timeLeft < 60.minutes && timeLeft > 58.minutes;

    var body = "Baro Ki'Teer has arrived";
    if (isLeaving) body = "Baro Ki'Teer is leaving soon";

    final isArriving = recurringEventLimiter(trader.activation);
    if (isArriving || isLeaving) {
      await auth.send(
        NotificationKeys.baroKey,
        Notification(title: "Baro Ki'Teer", body: body),
      );
    }
  }
}
