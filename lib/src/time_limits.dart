import 'package:time/time.dart';

bool recurringEventLimiter(DateTime start) {
  final now = DateTime.now().toUtc();
  final difference = start.difference(now).abs();

  return difference <= 1.minutes;
}
