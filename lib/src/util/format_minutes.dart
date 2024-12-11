// ignore_for_file: non_constant_identifier_names

String getVnLength(int? lengthInMinutes) {
  final int length_minutes = lengthInMinutes ?? 0; // e.g 2534
  final int hour = length_minutes ~/ 60; // e.g (2534 ~/ 60 = 41 Hours) Floor division
  final int minute = length_minutes % 60; // e.g (2534 % 60 = 14 Minutes) Modulus

  if (hour >= 100) return '${hour}H';

  if (hour != 0 && minute != 0) return '${hour}H ${minute}M';

  if (hour != 0 && minute == 0) return '${hour}H';

  if (hour == 0 && minute != 0) return '${minute}M';

  // (hour == 0 && minute == 0)
  return 'Unknown';
}
