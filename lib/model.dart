import 'package:calendar/repo/preference.dart';
import 'package:package_info/package_info.dart';

import 'repo/db.dart';

class AppModel {
  AppModel(
      {this.packageInfo, this.preferenceRepository, this.databaseRepository});

  final PackageInfo packageInfo;
  final DatabaseRepository databaseRepository;
  final PreferenceRepository preferenceRepository;
}
