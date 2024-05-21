import 'package:time/time.dart';

bool recurringEventLimiter(DateTime start) {
  final now = DateTime.timestamp();
  final difference = start.difference(now).abs();

  return difference < 60.seconds;
}
