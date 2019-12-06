import 'package:flutter/material.dart';

import '../preference.dart';

/*
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
*/

Color colorFromHex(String hexString) =>
    Color(int.parse(hexString.replaceFirst('#', ''), radix: 16));

final presets = {
  'default': <String, dynamic>{
    kColorWeekday: <int, int>{
      DateTime.sunday: Colors.red.value,
      DateTime.monday: Colors.black.value,
      DateTime.tuesday: Colors.black.value,
      DateTime.wednesday: Colors.black.value,
      DateTime.thursday: Colors.black.value,
      DateTime.friday: Colors.black.value,
      DateTime.saturday: Colors.blue.value,
    },
    kColorBackground: Colors.transparent.value,
    kColorBorder: Colors.grey.value,
    kColorToday: Colors.red.value,
    kColorOtherThanThisMonth: Colors.grey.value,
  },
  'test': <String, dynamic>{
    kColorWeekday: <int, int>{
      DateTime.sunday: Colors.red.value,
      DateTime.monday: Colors.black.value,
      DateTime.tuesday: Colors.black.value,
      DateTime.wednesday: Colors.black.value,
      DateTime.thursday: Colors.black.value,
      DateTime.friday: Colors.black.value,
      DateTime.saturday: Colors.blue.value,
    },
    kColorBackground: Colors.blue.shade50.value,
    kColorBorder: Colors.blue.shade100.value,
    kColorToday: Colors.blue.shade500.value,
    kColorOtherThanThisMonth: Colors.blue.shade200.value,
  }
};
