import 'package:time/time.dart';

bool recurringEventLimiter(DateTime start, {Duration? limit}) {
  final difference = start.difference(DateTime.now().toUtc()).abs();

  return difference >= (limit ?? 2.minutes);
}
