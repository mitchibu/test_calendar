import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/colors.dart';

const kColorWeekday = 'colorWeekday';
const kColorBackground = 'colorBackground';
const kColorBorder = 'colorBorder';
const kColorToday = 'colorToday';
const kColorOtherThanThisMonth = 'colorOtherThanThisMonth';

const kLastDate = 'lastDate';
const kLastPalette = 'lastPalette';

class PreferenceRepository {
  PreferenceRepository(this.sp);
  final SharedPreferences sp;
  final defaultColors = presets['test'];

  Color colorWeekDay(int weekday) {
    final Map<int, int> colors = defaultColors[kColorWeekday];
    return Color(sp.getInt('$kColorWeekday$weekday') ?? colors[weekday]);
  }

  Color get colorBackground =>
      Color(sp.getInt(kColorBackground) ?? defaultColors[kColorBackground]);
  Color get colorBorder =>
      Color(sp.getInt(kColorBorder) ?? defaultColors[kColorBorder]);
  Color get colorToday =>
      Color(sp.getInt(kColorToday) ?? defaultColors[kColorToday]);
  Color get colorOtherThanThisMonth =>
      Color(sp.getInt(kColorOtherThanThisMonth) ??
          defaultColors[kColorOtherThanThisMonth]);

  DateTime get lastDate => DateTime.fromMillisecondsSinceEpoch(
      sp.getInt(kLastDate) ?? DateTime.now().millisecondsSinceEpoch);

  void setlastDate(DateTime date) {
    sp.setInt(kLastDate, date.millisecondsSinceEpoch);
  }

  int get lastPalette => sp.getInt(kLastPalette) ?? 0;

  void setLastPalette(int position) {
    sp.setInt(kLastPalette, position);
  }
}
